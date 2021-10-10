<template>
  <app-main-container>
    <template v-slot:title>
      {{ user.name || user.email }}
    </template>

    <nuxt-child />
  </app-main-container>
</template>

<script>
export default {
  async fetch({ store, params }) {
    await store.dispatch("users/find", params.id);
  },

  computed: {
    user() {
      return this.$store.state.users?.user;
    }
  }
};
</script>
