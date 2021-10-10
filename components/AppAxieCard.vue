<template>
  <div>
    <v-card max-width="250" max-height="300" outlined>
      <v-chip
        class="subtitle-2 mt-3 ml-3"
        x-small
        :color="chipColor || _color"
        v-text="`#${axie.id}`"
      />
      <div class="caption white--text mt-1 ml-3">
        {{ axie.name }}
      </div>
      <div class="caption grey--text mt-n1 ml-3">
        Breed Count: {{ axie.breedCount }}
      </div>
      <v-card-text align="center" justify="center">
        <v-img :src="axie.image" max-height="200" max-width="200" />
      </v-card-text>

      <v-card-actions class="card-actions d-flex">
        <div class="caption grey--text ml-1">
          {{ axie.class }}
        </div>
      </v-card-actions>
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
          return "cyan lighten-2";

        case "Beast":
          return "yellow darken-2";

        case "Bird":
          return "pink";

        case "Plant":
          return "green darken-2";

        case "Reptile":
          return "purple lighten-2";

        case "Bug":
          return "orange darken-4";

        case "Dawn":
          return "purple lighten-4";

        case "Dusk":
          return "cyan darken-3";

        case "Mech":
          return "purple lighten-5";

        default:
          return "dark";
      }
    }
  }
};
</script>
