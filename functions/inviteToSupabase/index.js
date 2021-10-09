const { createClient } = require("@supabase/supabase-js");
require("dotenv").config();

exports.handler = async function(event, context) {
  const { email, sender } = JSON.parse(event.body);

  if (!email || !sender) {
    return {
      code: 400,
      message:
        "The `email` and `sender` field is required and both must be a valid email address."
    };
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { error } = await supabase.auth.api.inviteUserByEmail(email, {
    data: {
      inviteBy: sender
    }
  });

  if (error) {
    return {
      code: 422,
      error,
      message: error.message
    };
  }

  return {
    code: 200,
    message: `Invitation sent to ${email}.`
  };
};
