<template>
  <v-sheet color="transparent" height="100vh" width="100%">
    <app-nav-bar>
      <div class="title">
        App Name
      </div>

      <v-spacer></v-spacer>

      <v-btn depressed to="/auth/login">
        Sign In
      </v-btn>
    </app-nav-bar>

    <v-row>
      <v-col>
        <!-- <v-card class="logo py-4 d-flex justify-center">
          <NuxtLogo />
          <VuetifyLogo />
        </v-card> -->
        <div class="d-flex justify-center align-center" style="height: 80vh">
          <div>
            <div class="display-1">Powered by Supabase</div>
            <div class="text-center my-5">
              <v-btn
                color="primary"
                to="/auth/register"
                rounded
                x-large
                depressed
              >
                Get Started
              </v-btn>
            </div>
          </div>
        </div>
      </v-col>
    </v-row>
  </v-sheet>
</template>

<script>
export default {
  layout: "landing",

  auth: "guest",

  async created() {
    if (Object.keys(this.$route.query).length !== 0) {
      const { access_token, refresh_token } = this.$route.query;

      await this.$auth.setUserToken(access_token, refresh_token);
      await this.$store.dispatch("init");
      return;
    }

    const [_, queryString] = this.$route.fullPath.split("#");
    console.log({ first: _, last: queryString });

    if (queryString) {
      const path = `${window.location.origin}/?${queryString}`;
      window.location.replace(path);
      return;
    }
  }
};
</script>
