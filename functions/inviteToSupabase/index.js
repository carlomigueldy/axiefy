const { createClient } = require("@supabase/supabase-js");
require("dotenv").config();

exports.handler = async function(event, context) {
  const { email } = event;

  if (!email) {
    return {
      code: 400,
      message:
        "The `email` field is required and must be a valid email address."
    };
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const response = await supabase.auth.api.inviteUserByEmail(email);
  console.log(response);

  return {
    code: 200,
    message: `Invitation sent to ${email}.`
  };
};
