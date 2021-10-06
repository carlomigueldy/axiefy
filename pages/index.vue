<template>
  <app-main-container>
    <v-row justify="center" align="center">
      <v-col cols="12" sm="8" md="6">
        <v-card class="logo py-4 d-flex justify-center">
          <NuxtLogo />
          <VuetifyLogo />
        </v-card>
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
export default {
  async created() {
    await this.$auth.fetchUser();

    if (this.$auth.loggedIn) {
      const users = await this.$supabase.from("users").select();

      const authUser = this.$supabase.auth.user();

      console.log('this.$supabase.from("users").select()', { users, authUser });
      return;
    }

    // this.$router.replace("/login");
  }
};
</script>
