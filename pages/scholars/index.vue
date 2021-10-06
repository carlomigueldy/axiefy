<template>
  <app-main-container>
    <template v-slot:title>Scholars</template>

    <v-row>
      <v-col>
        <v-sheet width="250" color="transparent">
          <v-text-field
            v-model="search"
            placeholder="Search"
            outlined
            dense
          ></v-text-field>
        </v-sheet>

        <v-card min-height="585" outlined>
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
      <v-btn color="primary" depressed>Invite Scholar</v-btn>
    </template>
  </app-main-container>
</template>

<script>
export default {
  data: () => ({
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
      },
      {
        id: 4,
        email: "carlo4@gmail.com"
      },
      {
        id: 5,
        email: "carlo4@gmail.com"
      },
      {
        id: 6,
        email: "carlo6@gmail.com"
      },
      {
        id: 7,
        email: "carlo7@gmail.com"
      },
      {
        id: 8,
        email: "carlo8@gmail.com"
      },
      {
        id: 9,
        email: "carlo9@gmail.com"
      },
      {
        id: 10,
        email: "carlo10@gmail.com"
      },
      {
        id: 11,
        email: "carlo11@gmail.com"
      }
    ]
  })
};
</script>
