<template>
  <v-row>
    <v-col>
      <v-form ref="form" @submit.prevent="onSubmit">
        <v-card class="pa-5">
          <v-card-title>Login</v-card-title>
          <v-card-text>
            <v-text-field
              label="Email"
              type="email"
              v-model="form.email"
              :rules="rules.email"
            ></v-text-field>
            <v-text-field
              label="Password"
              type="password"
              v-model="form.password"
              :rules="rules.password"
            ></v-text-field>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn type="submit" color="primary" large>Submit</v-btn>
            <v-btn @click="fetchUser" large>Fetch User</v-btn>
            <v-btn @cilck="logout()" large>Logout</v-btn>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-col>
  </v-row>
</template>

<script>
export default {
  data: () => ({
    form: {
      email: "carlomigueldy@gmail.com",
      password: "password"
    }
  }),

  created() {},

  computed: {
    rules() {
      return {
        email: [v => !!v || "Email is required"],
        password: [v => !!v || "Password is required"]
      };
    }
  },

  methods: {
    async onSubmit() {
      if (!this.$refs.form.validate) return console.log("Form invalid");

      // const response = await this.$supabase.auth.signIn(this.form);
      const response = await this.$auth.login({ data: this.form });
      console.log("onSubmit", response);
      this.$auth.setUser(response.data?.user);
      // this.$auth.setUserToken(response.data?.refresh_token);
      console.log("this.$auth.user", this.$auth.user);
      console.log("this.$store.state.auth.user", this.$store.state?.auth?.user);
      console.log("this.$store.state", this.$store.state);

      console.log(
        "this.$auth.strategy.token.get()",
        this.$auth.strategy.token.get()
      );

      const userResponse = await this.$supabase
        .from("users")
        .select()
        .eq("id", response.data?.user?.id)
        .single();

      if (userResponse) {
        this.$store.commit("setUser", userResponse.data);
        console.log("this.$store.state.user", this.$store.state?.user);
      }

      console.log("this.$auth.loggedIn", this.$auth.loggedIn);
      console.log(
        "this.$store.state.auth.loggedIn",
        this.$store.state?.auth?.loggedIn
      );
    },
    async fetchUser() {
      const response = await this.$auth.fetchUser();

      console.log("fetchUser", response);
    },
    async logout() {
      console.log("logout called");

      const response = await this.$auth.logout({ strategy: "local" });

      console.log("logout", response);
    }
  }
};
</script>
