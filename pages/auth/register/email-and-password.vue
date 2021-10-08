<template>
  <div>
    <v-card-text class="mt-16">
      <v-text-field
        label="Name"
        type="email"
        v-model="form.name"
        outlined
        dense
      ></v-text-field>
      <v-text-field
        label="Email"
        type="email"
        v-model="form.email"
        :rules="rules.email"
        outlined
        dense
      ></v-text-field>
      <v-text-field
        label="Password"
        type="password"
        v-model="form.password"
        :rules="rules.password"
        outlined
        dense
      ></v-text-field>
    </v-card-text>
    <v-card-actions>
      <div>
        <span>Already have an account?</span>
        <nuxt-link replace :to="{ name: 'auth-login' }">
          Sign-in instead
        </nuxt-link>
      </div>
      <v-spacer></v-spacer>
      <v-btn type="submit" :loading="loading$" color="primary">
        Create Account
      </v-btn>
    </v-card-actions>
  </div>
</template>

<script>
const authMethods = [
  {
    title: "Magic Link",
    subtitle: "Create an account via Magic Link",
    icon: "mdi-auto-fix"
  },
  {
    title: "Email & Password",
    subtitle: "Create an account with Email and Password",
    icon: "mdi-email"
  },
  {
    title: "GitHub",
    subtitle: "Create an account via GitHub",
    logo: "https://cdn-icons-png.flaticon.com/512/25/25231.png"
  },
  {
    title: "Discord",
    subtitle: "Create an account via Discord",
    logo:
      "https://www.freepnglogos.com/uploads/discord-logo-png/discord-logo-logodownload-download-logotipos-1.png"
  },
  {
    title: "Google",
    subtitle: "Create an account via Google",
    logo:
      "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png"
  },
  {
    title: "Twitter",
    subtitle: "Create an account via Twitter",
    logo:
      "https://www.freepnglogos.com/uploads/twitter-logo-png/twitter-logo-vector-png-clipart-1.png"
  }
];

export default {
  head: {
    title: "Create Account"
  },

  layout: "auth",

  auth: "guest",

  data: () => ({
    loading$: false,
    authMethod: null,
    form: {
      name: "",
      email: "",
      password: ""
    }
  }),

  created() {},

  computed: {
    authMethods() {
      return authMethods;
    },

    rules() {
      return {
        email: [v => !!v || "Email is required"],
        password: [v => !!v || "Password is required"]
      };
    }
  },

  methods: {
    onAuthMethodSelected(method) {
      this.authMethod = method;
    },
    async onSubmit() {
      this.loading$ = true;

      if (!this.$refs.form.validate) return this.$log.info("Form invalid");

      try {
        const { email, password, name } = this.form;
        const response = await this.$supabase.auth.signUp({
          email,
          password
        });
        this.$log.info("onSubmit", response);
        await this.$auth.setUserToken(
          response.data.access_token,
          response.data.refresh_token
        );
        await this.$auth.fetchUser();
        const fetchUserResponse = await this.$store.dispatch(
          "fetchUser",
          response.data
        );

        const updateUserResponse = await this.$supabase
          .from("users")
          .update({
            name
          })
          .eq("id", fetchUserResponse.data?.id);
        this.$log.info("updateUserResponse", updateUserResponse);

        await this.$store.dispatch("fetchUser", response.data);

        // this.$router.replace("/dashboard");

        // this.$auth.init();
      } catch (error) {
        this.$log.error(error);
      } finally {
        this.loading$ = false;
      }
    },
    async fetchUser() {
      const response = await this.$auth.fetchUser();

      this.$log.info("fetchUser", response);
    },
    async signOut() {
      this.$log.info("logout called");

      const response = await this.$auth.logout();

      this.$log.info("logout", response);
    }
  }
};
</script>
