<template>
  <div>
    <v-card outlined>
      <v-card-title>Danger Zone</v-card-title>
      <v-divider></v-divider>
      <v-card-text>
        <div class="subtitle-1">Disable your account</div>
        <v-sheet height="25" color="transparent"></v-sheet>
        <v-btn @click="dialog = true" outlined large color="error">
          Disable Account
        </v-btn>
      </v-card-text>
    </v-card>

    <app-disable-account-dialog v-model="dialog" />
  </div>
</template>

<script>
export default {
  data: () => ({
    dialog: false
  })
};
</script>
