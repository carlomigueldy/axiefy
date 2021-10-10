<template>
  <v-list>
    <v-list-item
      v-for="(method, index) in authMethods"
      :key="index"
      class="my-2"
      @click="onAuthMethodSelected(method)"
    >
      <v-list-item-content>
        <v-list-item-title>{{ method.title }}</v-list-item-title>
        <v-list-item-subtitle>
          {{ method.subtitle }}
        </v-list-item-subtitle>
      </v-list-item-content>
      <v-list-item-action>
        <v-icon v-if="method.icon" v-text="method.icon" />
        <v-img v-else :src="method.logo" height="25" width="25" />
      </v-list-item-action>
    </v-list-item>
  </v-list>
</template>

<script>
export default {
  head: {
    title: "Select Auth Method"
  },

  layout: "auth",

  auth: "guest",

  data: () => ({
    authMethod: null
  }),

  computed: {
    authMethods() {
      return [
        {
          title: "Magic Link",
          subtitle: "Create an account via Magic Link",
          icon: "mdi-auto-fix",
          route: "magic-link"
        },
        {
          title: "Email & Password",
          subtitle: "Create an account with Email and Password",
          icon: "mdi-email",
          route: "email-and-password"
        },

        ...this.$store.state.oauthProviders
      ];
    }
  },

  methods: {
    async onAuthMethodSelected(method) {
      this.authMethod = method;
      const { provider } = method;

      if (method.route) {
        return this.$router.push({ name: `auth-register-${method.route}` });
      }

      try {
        const response = await this.$supabase.auth.signIn({
          provider
        });
        this.$log.info(response);
        await this.$store.dispatch('init')
      } catch (error) {
        this.$toast.showUnexpectedError();
        this.$log.error(error, { method, provder });
      }
    }
  }
};
</script>
