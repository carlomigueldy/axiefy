<template>
  <v-card class="rounded pa-10" elevation="24" width="300" height="425">
    <v-card-text class="d-flex justify-center align-center fill-height">
      <div class="text-center">
        <div class="display-1 white--text">
          <slot>{{ title }}</slot>
        </div>
        <div class="subtitle-1" v-text="subtitle" />
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    title: String,

    subtitle: String
  }
};
</script>
