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
            <template v-slot:[`item.ronin_address`]="{ item }">
              <span
                v-text="$stringUtil.truncateWallet(item.ronin_address)"
                class="subtitle-1 pa-5"
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
                </v-list>
              </v-menu>
            </template>
          </v-data-table>
        </v-card>

        <v-sheet color="transparent" height="100"></v-sheet>
      </v-col>
    </v-row>

    <template v-slot:action>
      <v-btn
        color="primary"
        style="box-shadow: 0 0 20px var(--rgba-blue-darken-2);"
        depressed
        @click="onClickInviteScholar"
      >
        Invite Scholar
      </v-btn>
    </template>

    <v-dialog v-model="dialog.inviteScholar" width="500">
      <app-dialog-card>
        <v-card-title>Invite Scholar</v-card-title>
        <v-card-text>
          <p>
            Inviting a scholar will send them a confirmation link in their
            email.
          </p>
          <v-text-field
            v-model="inviteScholarEmail"
            class="mt-10"
            outlined
            label="Email"
            dense
          ></v-text-field>
          <v-card-actions>
            <v-spacer></v-spacer>
            <div>
              <v-btn @click="dialog.inviteScholar = false" text>Cancel</v-btn>
              <v-btn
                @click="inviteScholar"
                :loading="inviteScholarLoading$"
                depressed
                color="primary"
              >
                Invite
              </v-btn>
            </div>
          </v-card-actions>
        </v-card-text>
      </app-dialog-card>
    </v-dialog>
  </lazy-app-main-container>
</template>

<script>
export default {
  async created() {
    if (this.$store.state.scholars.length !== 0) {
      return;
    }

    try {
      this.getTeamMembersLoading$ = true;
      const response = await this.$store.dispatch("rpc", "get_team_members");
      this.$store.commit("setScholars", response);
    } catch (error) {
      console.error(error);
    } finally {
      this.getTeamMembersLoading$ = false;
    }
  },

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
        width: "5%"
      },
      {
        text: "Action",
        value: "action",
        sortable: false,
        align: "center",
        width: "30%"
      }
    ]
  }),

  methods: {
    onClickWalletAddress(address) {
      this.$copyText(address);
    },

    onClickInviteScholar() {
      this.dialog.inviteScholar = true;
    },

    async inviteScholar() {
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

        this.$log.info(data);
        this.inviteScholarEmail = "";
      } catch (error) {
        this.$log.error(error);
      } finally {
        this.dialog.inviteScholar = false;
        this.inviteScholarLoading$ = false;
      }
    }
  }
};
</script>
