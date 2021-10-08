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
const authMethods = [
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
  {
    provider: "github",
    title: "GitHub",
    subtitle: "Create an account via GitHub",
    logo: "https://cdn-icons-png.flaticon.com/512/25/25231.png"
  },
  {
    provider: "discord",
    title: "Discord",
    subtitle: "Create an account via Discord",
    logo:
      "https://www.freepnglogos.com/uploads/discord-logo-png/discord-logo-logodownload-download-logotipos-1.png"
  },
  {
    provider: "google",
    title: "Google",
    subtitle: "Create an account via Google",
    logo:
      "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png"
  },
  {
    provider: "twitter",
    title: "Twitter",
    subtitle: "Create an account via Twitter",
    logo:
      "https://www.freepnglogos.com/uploads/twitter-logo-png/twitter-logo-vector-png-clipart-1.png"
  }
];

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
      return authMethods;
    }
  },

  methods: {
    async onAuthMethodSelected(method) {
      this.authMethod = method;

      if (method.route) {
        return this.$router.push({ name: `auth-register-${method.route}` });
      }

      switch (method.provider) {
        case "discord":
          const response = await this.$supabase.auth.signIn({
            provider: "discord"
          });
          this.$log.info(response);
          break;

        default:
          break;
      }
    }
  }
};
</script>
