<template>
  <app-main-container>
    <v-row>
      <v-col>
        Dashboard
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
import AppMainContainer from "~/components/AppMainContainer.vue";
export default {
  components: { AppMainContainer },

  async created() {
    try {
      const response = await this.$store.dispatch("rpc", "get_team_members");
      this.$store.commit("setScholars", response);
    } catch (error) {
      console.error(error);
    }
  }
};
</script>

<style></style>
