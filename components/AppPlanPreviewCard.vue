<template>
  <v-card
    class="rounded pa-10 card-outter"
    elevation="24"
    width="300"
    height="425"
    hover
  >
    <v-card-text class="d-flex justify-center align-center fill-height">
      <div class="text-center">
        <div class="display-2">{{ emoji }}</div>
        <div class="display-1 white--text">
          <slot>{{ title }}</slot>
        </div>
        <div class="subtitle-2" v-text="subtitle" />
      </div>
    </v-card-text>
    <v-card-actions class="card-actions d-flex justify-center">
      <div class="caption grey--text" color="gray" v-text="description" />
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    title: String,

    subtitle: String,

    description: String,

    emoji: String
  }
};
</script>
