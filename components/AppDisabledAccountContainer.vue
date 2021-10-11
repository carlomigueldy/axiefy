<template>
  <v-container fill-height>
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
</template>

<script>
export default {};
</script>

