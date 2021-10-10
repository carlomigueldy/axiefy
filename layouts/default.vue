<template>
  <v-app dark>
    <v-container
      fill-height
      v-if="$store.getters.userDisabled && !initializing$"
    >
      <v-row justify="center" align="center">
        <v-col>
          <div class="text-center ">
            <div class="display-1 error--text">Account Disabled</div>
            <div class="subtitle-1 mb-5">
              <span>Send a message to re-enable your account at</span>
              <app-main-author-email />
            </div>
            <v-btn @click="logout" x-large text>Ok</v-btn>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <div
      ref="wrapper"
      v-else-if="!$store.getters.userDisabled && !initializing$"
    >
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
            <app-tooltip message="Coming soon">
              <v-btn
                depressed
                color="secondary"
                class="rounded-lg"
                style="box-shadow: 0 0px 15px var(--rgba-amber-darken-3);"
                @click="toBillingSection"
              >
                👑 Get Premium
              </v-btn>
            </app-tooltip>
          </div>

          <v-list-item
            :to="{
              name: 'settings'
            }"
            class="px-3 py-1"
          >
            <v-list-item-avatar color="black">
              <v-img :src="userProfileImage" color="black" />
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
    </div>

    <v-container fill-height v-else-if="initializing$">
      <v-row justify="center" align="center">
        <v-col>
          <div class="text-center ">
            <div class="title">Discovering new ways of making you wait ...</div>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <v-dialog v-model="dialog.logoutConfirmation" width="500">
      <app-dialog-card>
        <v-card-title>Is this goodbye?</v-card-title>
        <v-card-text>
          <div class="rounded my-5">
            <div
              style="width:100%;height:0;padding-bottom:56%;position:relative;"
            >
              <iframe
                src="https://giphy.com/embed/vxNCVEe0PI9A3YVJEX"
                width="100%"
                height="100%"
                style="position:absolute"
                frameBorder="0"
                class="giphy-embed"
                allowFullScreen
              ></iframe>
            </div>
            <p>
              <a
                href="https://giphy.com/gifs/athomewithamysedaris-amy-sedaris-at-home-with-ah208-vxNCVEe0PI9A3YVJEX"
              >
                via GIPHY
              </a>
            </p>
          </div>

          <p>
            Are you sure you want to logout?
          </p>
        </v-card-text>
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
    initializing$: false,
    loggingOut$: false,
    userProfileImage: "",
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
      // {
      //   icon: "mdi-apps",
      //   title: "Settings",
      //   to: "/settings"
      // },
      {
        icon: "mdi-apps",
        title: "About",
        to: "/about"
      }
    ],
    appName: "App Name"
  }),

  async created() {
    this.initializing$ = true;

    try {
      console.log("Init");
      await this.$store.dispatch("init");

      this.userProfileImage = await this.$store.dispatch("getProfileImage");
    } catch (error) {
      console.error(error);
    } finally {
      setTimeout(() => {
        this.initializing$ = false;
        this.$toast("Still faster than Windows update 😉");
      }, 3000);
    }
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
    async logout() {
      try {
        this.loggingOut$ = true;
        await this.$auth.logout();
      } catch (error) {
        console.error(error);
      } finally {
        this.loggingOut$ = false;
      }
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
