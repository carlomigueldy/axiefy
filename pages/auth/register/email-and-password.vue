<template>
  <v-form ref="form" @submit.prevent="onSubmit">
    <v-card-text class="mt-16">
      <v-text-field
        label="Name"
        type="email"
        v-model="form.name"
        aria-autocomplete="none"
        autocomplete="new-name"
        outlined
        dense
      ></v-text-field>
      <v-text-field
        label="Email"
        type="email"
        v-model="form.email"
        :rules="rules.email"
        aria-autocomplete="none"
        autocomplete="new-email"
        outlined
        dense
      ></v-text-field>
      <v-text-field
        label="Password"
        type="password"
        v-model="form.password"
        :rules="rules.password"
        aria-autocomplete="none"
        autocomplete="new-password"
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
  </v-form>
</template>

<script>
export default {
  head: {
    title: "Email & Password"
  },

  layout: "auth",

  auth: "guest",

  data: () => ({
    loading$: false,
    form: {
      name: "",
      email: "",
      password: ""
    }
  }),

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
      } catch (error) {
        this.$log.error(error);
      } finally {
        this.loading$ = false;
      }
    }
  }
};
</script>
