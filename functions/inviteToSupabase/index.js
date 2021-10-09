const { createClient } = require("@supabase/supabase-js");
require("dotenv").config();

exports.handler = async function(event, context) {
  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { email } = JSON.parse(event?.body || "{}");
  const headers = event?.headers;

  if (!email) {
    return {
      code: 400,
      message:
        "The `email` field is required and must be a valid email address."
    };
  }

  if (!headers["Authorization"]) {
    return {
      code: 401,
      message: `No request header "Authorization" found.`
    };
  }

  try {
    const {
      error: authError,
      user: authUser
    } = await supabase.auth.api.getUser(
      headers["Authorization"].split("Bearer ")[1]
    );

    if (authError) {
      const message = "You are not authenticated.";
      console.error(message, authError);
      return {
        code: 401,
        error: authError,
        message
      };
    }

    const {
      data: inviteData,
      error: inviteError
    } = await supabase.auth.api.inviteUserByEmail(email, {
      data: {
        invited_by: authUser
      }
    });

    if (inviteError) {
      return {
        code: 422,
        error: inviteError,
        message: inviteError.message
      };
    }

    const { data: team, error: teamError } = await supabase
      .from("teams")
      .select()
      .eq("owner_id", authUser.id)
      .single();

    if (teamError) {
      const message = `The user did not have a Team`;
      console.error(message, teamError);
      return {
        code: 500,
        message,
        error: teamError
      };
    }

    const {
      data: teamMemberData,
      error: teamMemberError
    } = await supabase.from("team_members").insert({
      user_id: inviteData.id,
      team_id: team.id
    });

    if (teamMemberError) {
      const message = `Error ocurred when inserting a record for "team_members"`;
      console.error(message, teamMemberError);
      return {
        code: 500,
        message,
        error: teamMemberError
      };
    }

    return {
      code: 200,
      message: `Invitation sent to ${email}.`,
      data: {
        teamMemberData,
        inviteData
      }
    };
  } catch (error) {
    return {
      error
    };
  }
};
