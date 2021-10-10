<template>
  <v-sheet
    height="100vh"
    width="100%"
    color="red"
    class="d-flex justify-space-between"
  >
    <v-sheet width="60%">
      <v-img
        src="https://images.pexels.com/photos/730564/pexels-photo-730564.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
        width="100%"
        height="100%"
      ></v-img>
      <!-- <div
        style="position: absolute; height: 100%; width: 100%; backdrop-filter: blur(12px); background-color: rgba(26, 26, 26, 0.2);"
      ></div> -->
    </v-sheet>
    <v-sheet class="d-flex justify-center align-center pa-5" width="40%">
      <v-form style="width: 100%" ref="form" @submit.prevent="onSubmit">
        <v-card class="pa-0" color="transparent" flat>
          <v-card-title class="display-1">Login</v-card-title>
          <v-card-subtitle>Manage your scholars</v-card-subtitle>
          <v-card-text class="mt-16">
            <v-text-field
              name="email"
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
              <span>Don't have an account yet?</span>
              <nuxt-link replace :to="{ name: 'auth-register' }">
                Create an account
              </nuxt-link>
            </div>
            <v-spacer></v-spacer>
            <v-btn type="submit" :loading="loading$" color="primary">
              Login
            </v-btn>
          </v-card-actions>
          <!-- <div class="d-flex justify-space-around align-center mt-10">
            <v-sheet
              v-for="(method, index) in $store.state.oauthProviders"
              :key="index"
              style="border-radius: 50%; cursor: pointer"
              height="50"
              width="50"
              @click="signInWithProvider(method)"
            >
              <v-img :src="method.logo" height="50" width="50" />
            </v-sheet>
          </div> -->
        </v-card>
      </v-form>
    </v-sheet>
  </v-sheet>
</template>

<script>
export default {
  head: {
    title: "Sign In"
  },

  layout: "auth",

  data: () => ({
    loading$: false,
    form: {
      email: "",
      password: ""
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
    async signInWithProvider(oauth) {
      const { provider } = oauth;
      const response = await this.$supabase.auth.signIn({
        provider
      });
      this.$log.info(response);
    },
    async onSubmit() {
      this.loading$ = true;

      if (!this.$refs.form.validate) return this.$log.info("Form invalid");

      try {
        const response = await this.$auth.login({ data: this.form });
        this.$log.info("onSubmit", response);

        this.$log.info("this.$auth.user", this.$auth.user);
        this.$log.info("this.$auth.loggedIn", this.$auth.loggedIn);

        this.$store.dispatch("fetchUser", response.data);
        this.$toast("You have logged in");
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
