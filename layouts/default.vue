<template>
  <v-app dark>
    <v-navigation-drawer
      color="grey darken-4"
      :value="$store.state.drawer"
      @input="onChangeDrawer"
      fixed
      app
    >
      <v-sheet
        color="transparent"
        class="pa-5 d-flex justify-center"
        width="100%"
      >
        <div class="title">{{ appName }}</div>
      </v-sheet>

      <v-list nav>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
          dense
        >
          <!-- <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action> -->
          <v-list-item-content>
            <v-list-item-title v-text="item.title" class="subtitle-1" />
          </v-list-item-content>
        </v-list-item>

        <v-list-item @click="dialog.logoutConfirmation = true" dense>
          <v-list-item-content>
            <v-list-item-title class="subtitle-1">
              Logout
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>

      <div style="position: absolute; bottom: 0; left: 0; right: 0">
        <div class="d-flex justify-center py-3">
          <v-btn
            depressed
            color="secondary"
            class="rounded-lg"
            style="box-shadow: 0 0px 15px var(--rgba-amber-darken-3);"
            @click="toBillingSection"
          >
            Get Premium
          </v-btn>
        </div>

        <v-list-item @click="onClickUser" class="px-3 py-1">
          <v-list-item-avatar>
            <v-img src="supabase-logo.jpg"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-list-item-title>
              {{ userFullName }}
            </v-list-item-title>
            <v-list-item-subtitle>{{ userEmail }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </div>
    </v-navigation-drawer>

    <Nuxt />

    <v-dialog v-model="dialog.logoutConfirmation" width="500">
      <app-dialog-card>
        <v-card-title>Logout</v-card-title>
        <v-card-text>Are you sure you want to logout?</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            :disabled="loggingOut$"
            @click="dialog.logoutConfirmation = false"
            text
          >
            Cancel
          </v-btn>
          <v-btn color="error" :loading="loggingOut$" depressed @click="logout">
            Confirm
          </v-btn>
        </v-card-actions>
      </app-dialog-card>
    </v-dialog>

    <lazy-app-snackbar />
  </v-app>
</template>

<script>
export default {
  data: () => ({
    drawer: true,
    loggingOut$: false,
    dialog: {
      logoutConfirmation: false
    },
    items: [
      {
        icon: "mdi-apps",
        title: "Dashboard",
        to: "/dashboard"
      },
      {
        icon: "mdi-apps",
        title: "Scholars",
        to: "/scholars"
      },
      {
        icon: "mdi-apps",
        title: "Settings",
        to: "/settings"
      },
      {
        icon: "mdi-apps",
        title: "About",
        to: "/about"
      }
    ],
    appName: "App Name"
  }),

  created() {
    this.$store.dispatch("fetchUser");
  },

  computed: {
    userFullName() {
      return this.$store.state?.user?.name ?? "Unknown";
    },

    userEmail() {
      return this.$auth.user?.email;
    }
  },

  methods: {
    onClickUser() {
      console.log("onClickUser");
      this.$router.push({
        name: "settings"
      });
    },

    logout() {
      this.$auth.logout();
    },

    toBillingSection() {
      this.$router.push({ name: "settings", query: { section: "billing" } });
    },

    onChangeDrawer(event) {
      console.log(event);
      this.$store.commit("toggleDrawer", event);
    }
  }
};
</script>
