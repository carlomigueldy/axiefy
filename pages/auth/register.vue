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
          <v-card-title class="display-1">Create Account</v-card-title>
          <v-card-subtitle>Manage your scholars</v-card-subtitle>
          <v-card-text class="mt-16">
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
        </v-card>
      </v-form>
    </v-sheet>
  </v-sheet>
</template>

<script>
export default {
  head: {
    title: "Create Account"
  },

  layout: "auth",

  auth: "guest",

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
    async onSubmit() {
      this.loading$ = true;

      if (!this.$refs.form.validate) return this.$log.info("Form invalid");

      try {
        const response = await this.$supabase.auth.signUp(this.form);
        await this.$auth.setUserToken(
          response.data.access_token,
          response.data.refresh_token
        );
        await this.$auth.fetchUser();
        await this.$store.dispatch("fetchUser", response.data);
        this.$router.replace("/");
        this.$log.info("onSubmit", response);
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

<!-- <template>
  <v-row>
    <v-col>
      <v-form ref="form" @submit.prevent="onSubmit">
        <v-card class="pa-5">
          <v-card-title>Register</v-card-title>
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
          </v-card-actions>
        </v-card>
      </v-form>
    </v-col>
  </v-row>
</template>

<script>
export default {
  layout: "auth",

  auth: "guest",

  data: () => ({
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
    async onSubmit() {
      if (!this.$refs.form.validate) return this.$log.info("Form invalid");

      const response = await this.$supabase.auth.signUp(this.form);
      await this.$auth.setUserToken(
        response.data.access_token,
        response.data.refresh_token
      );
      await this.$auth.fetchUser();
      await this.$store.dispatch("fetchUser", response.data);
      this.$router.replace("/");
      this.$log.info("onSubmit", response);
    }
  }
};
</script> -->
