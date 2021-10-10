<template>
  <div>
    <v-card max-width="250" min-height="250" outlined>
      <v-chip
        class="subtitle-2 mt-3 ml-3"
        x-small
        :color="chipColor || _color"
        v-text="`#${axie.id}`"
      />
      <v-card-text align="center" justify="center">
        <v-img :src="axie.image" max-height="200" max-width="200" />
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
export default {
  props: {
    axie: {
      type: Object,
      default: () => {}
    },
    chipColor: {
      type: String,
      default: () => null
    }
  },

  computed: {
    _color() {
      switch (this.axie.class) {
        case "Aquatic":
          return "blue";

        case "Beast":
          return "orange";

        case "Bird":
          return "pink lighten-3";

        case "Plant":
          return "green";

        default:
          return "dark";
      }
    }
  }
};
</script>
