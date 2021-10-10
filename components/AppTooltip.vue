<template>
  <div>
    <v-tooltip bottom>
      <template v-slot:activator="{ on, attrs }">
        <div v-bind="attrs" v-on="on" style="display: table;">
          <slot />
        </div>
      </template>
      <span v-text="message" />
    </v-tooltip>
  </div>
</template>

<script>
export default {
  props: {
    message: {
      type: String
    }
  }
};
</script>
