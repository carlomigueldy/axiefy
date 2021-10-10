<template>
  <lazy-app-main-container>
    <template v-slot:title>Scholars</template>

    <v-row>
      <v-col>
        <v-sheet width="250" color="transparent">
          <v-text-field
            prepend-inner-icon="mdi-magnify"
            v-model="search"
            placeholder="Search"
            outlined
            dense
          ></v-text-field>
        </v-sheet>

        <v-card outlined>
          <v-data-table
            :search="search"
            :headers="headers"
            :items="$store.state.scholars"
            :items-per-page="10"
            :loading="getTeamMembersLoading$"
          >
            <!-- @click:row="onClickItem" -->
            <template v-slot:[`item.ronin_address`]="{ item }">
              <v-chip
                v-if="item.ronin_address"
                color="orange"
                v-text="
                  $stringUtil.truncateAddress(
                    $stringUtil.extractRoninAddress(item.ronin_address)
                  )
                "
                class="subtitle-1"
                style="cursor: pointer"
                @click="onClickWalletAddress(item.ronin_address)"
              />
            </template>
            <template v-slot:[`item.action`]="{ item }">
              <v-menu offset-y>
                <template v-slot:activator="{ on, attrs }">
                  <v-btn v-bind="attrs" icon v-on="on">
                    <v-icon>mdi-dots-horizontal</v-icon>
                  </v-btn>
                </template>
                <v-list>
                  <v-list-item
                    @click="
                      $router.push({
                        name: 'scholars-id',
                        params: { id: item.id }
                      })
                    "
                  >
                    <v-list-item-title>View Scholar</v-list-item-title>
                  </v-list-item>

                  <v-list-item
                    @click="
                      $router.push({
                        name: 'scholars-id-edit',
                        params: { id: item.id }
                      })
                    "
                  >
                    <v-list-item-title>Edit Scholar</v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-menu>
            </template>
          </v-data-table>
        </v-card>

        <v-sheet color="transparent" height="100"></v-sheet>
      </v-col>
    </v-row>

    <template v-slot:action>
      <app-tooltip bottom message="Invite a Scholar">
        <v-btn
          color="primary"
          style="box-shadow: 0 0 20px var(--rgba-blue-darken-2);"
          depressed
          @click="onClickInviteScholar"
        >
          Hire Laborer
        </v-btn>
      </app-tooltip>
    </template>

    <v-dialog v-model="dialog.inviteScholar" width="500">
      <v-form ref="inviteForm" @submit.prevent="inviteScholar">
        <app-dialog-card>
          <v-card-title>🎓 Invite Scholar</v-card-title>
          <v-card-text>
            <div class="rounded my-5">
              <div
                style="width:100%;height:0;padding-bottom:56%;position:relative;"
              >
                <iframe
                  src="https://giphy.com/embed/befaYZCgtZfZm"
                  width="100%"
                  height="100%"
                  style="position:absolute"
                  frameBorder="0"
                  class="giphy-embed"
                  allowFullScreen
                ></iframe>
              </div>
              <p>
                <a href="https://giphy.com/gifs/ussr-befaYZCgtZfZm">
                  via GIPHY
                </a>
              </p>
            </div>

            <p>
              Inviting a labo... I mean Scholar will send them a confirmation
              link in their email.
            </p>
            <v-text-field
              v-model="inviteScholarEmail"
              class="mt-10"
              outlined
              label="Email"
              dense
              :rules="$store.getters.validationRules.required"
            ></v-text-field>
            <v-card-actions>
              <v-spacer></v-spacer>
              <div>
                <v-btn @click="dialog.inviteScholar = false" text>Cancel</v-btn>
                <v-btn
                  type="submit"
                  :loading="inviteScholarLoading$"
                  depressed
                  color="primary"
                >
                  Invite 🎉
                </v-btn>
              </div>
            </v-card-actions>
          </v-card-text>
        </app-dialog-card>
      </v-form>
    </v-dialog>
  </lazy-app-main-container>
</template>

<script>
export default {
  data: () => ({
    inviteScholarEmail: "",
    inviteScholarLoading$: false,
    getTeamMembersLoading$: false,
    dialog: {
      inviteScholar: false
    },
    search: "",
    headers: [
      {
        text: "Email",
        value: "email"
      },
      {
        width: "20%",
        text: "Name",
        value: "name"
      },
      {
        text: "Ronin Wallet",
        value: "ronin_address",
        width: "15%"
      },
      {
        text: "Action",
        value: "action",
        sortable: false,
        align: "center",
        width: "30%"
      }
    ],
    usersSubscription$: null
  }),

  async created() {
    this.usersSubscription$ = this.$supabase
      .from("users")
      .on("INSERT", event => {
        if (event.new) {
          this.$store.commit("addScholar", event.new);
        }
      })
      .subscribe();

    if (this.$store.state.scholars.length !== 0) {
      return;
    }

    try {
      this.getTeamMembersLoading$ = true;
      const response = await this.$store.dispatch("rpc", "get_team_members");
      this.$store.commit("setScholars", response);
    } catch (error) {
        this.$toast.showUnexpectedError();
      console.error(error);
    } finally {
      this.getTeamMembersLoading$ = false;
    }
  },

  destroyed() {
    console.log("destroyed");
    this.usersSubscription$?.unsubscribe();
  },

  methods: {
    onClickItem(item) {
      console.log("onClickItem", item);
      this.$router.push({
        name: "scholars-id",
        params: { id: item.id }
      });
    },

    onClickWalletAddress(address) {
      this.$copyText(address);
      this.$toast.show("Wallet address copied to clipboard.");
    },

    onClickInviteScholar() {
      this.dialog.inviteScholar = true;
    },

    async inviteScholar() {
      if (!this.$refs.inviteForm.validate()) {
        return this.$toast.show("Must provide an email address");
      }

      this.inviteScholarLoading$ = true;

      try {
        const { data } = await this.$store.dispatch(
          "inviteToSupabase",
          this.inviteScholarEmail
        );
        console.log(data);

        if (data.code !== 200) {
          console.error("Error", data);
          this.$log.error(data);
          return;
        }

        this.$confetti.start();

        this.$log.info(data);
        this.$toast.show(`You have successfully invited ${this.inviteScholarEmail}`);
        this.inviteScholarEmail = "";

        setTimeout(() => {
          this.$confetti.stop();
        }, 6000);
      } catch (error) {
        this.$toast.showUnexpectedError();
        this.$log.error(error);
        this.$toast.show("An error occurred, try again later");
      } finally {
        this.dialog.inviteScholar = false;
        this.inviteScholarLoading$ = false;
      }
    }
  }
};
</script>
