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
            :items="items"
            :items-per-page="10"
          >
            <template v-slot:[`item.action`]>
              <v-btn width="80" depressed small>Edit</v-btn>
              <v-btn width="80" depressed small>Remove</v-btn>
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
import axios from "axios";

export default {
  data: () => ({
    inviteScholarEmail: "",
    inviteScholarLoading$: false,
    dialog: {
      inviteScholar: false
    },
    search: "",
    headers: [
      {
        text: "#",
        value: "id"
      },
      {
        text: "Email",
        value: "email"
      },
      {
        text: "Action",
        value: "action",
        sortable: false,
        align: "center",
        width: "30%"
      }
    ],
    items: [
      {
        id: 1,
        email: "carlo@gmail.com"
      },
      {
        id: 2,
        email: "carlo2@gmail.com"
      },
      {
        id: 3,
        email: "carlo3@gmail.com"
      }
    ]
  }),

  methods: {
    onClickInviteScholar() {
      this.dialog.inviteScholar = true;
    },

    /** @todo move logic in a serverless function */
    async inviteScholar() {
      this.inviteScholarLoading$ = true;
      try {
        const { data } = await axios.post(
          `${this.$config.AWS_API_BASE_URL}/inviteToSupabase`,
          {
            email: this.inviteScholarEmail,
            sender: this.$auth.user.email
          },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem('auth._token.local')}`
            }
          }
        );

        if (data.code != 200) {
          console.error("Error", data);
          this.$log.error(data);
          return;
        }

        this.$log.info(response);
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
