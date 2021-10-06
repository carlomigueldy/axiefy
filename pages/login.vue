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

      const response = await this.$supabase.auth.signIn(this.form);
      console.log("onSubmit", response);

      this.$store.commit("setUser", response?.data?.user);
      console.log("this.$store.state?.user", this.$store.state?.user);
    }
  }
};
</script>
