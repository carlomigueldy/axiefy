<template>
  <div>
    <v-snackbar :value="$store.state.snackbar.value" @input="onInput">
      {{ $store.state.snackbar.message }}

      <template v-slot:action="{ attrs }">
        <v-btn
          color="primary"
          class="subtitle-2 font-weight-bold"
          text
          v-bind="attrs"
          @click="$store.commit('toggleSnackbar', false)"
        >
          Close
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script>
export default {
  methods: {
    onInput(event) {
      console.log({ event });
      this.$store.commit("toggleSnackbar", event);
    }
  }
};
</script>

<style></style>
