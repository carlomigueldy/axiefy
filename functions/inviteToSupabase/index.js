const { createClient } = require("@supabase/supabase-js");
require("dotenv").config();

exports.handler = async function(event, context) {
  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const response = await supabase.auth.api.inviteUserByEmail(
    "carlomigueldy@gmail.com"
  );
  console.log(response);
};
