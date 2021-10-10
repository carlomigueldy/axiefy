<template>
  <v-card min-height="70">
    <v-card-title>
      <v-row class="pt-5 px-5" align="center" justify="center">
        <slot name="image">
          <v-img
            :src="imageUrl"
            :height="imageSize || imageHeight"
            :width="imageSize || imageWidth"
          />
        </slot>
        <div class="headline-1 mx-3">
          <slot>
            {{ value }}
          </slot>
        </div>
      </v-row>
    </v-card-title>
    <v-row justify="center">
      <v-card-title v-text="title" />
    </v-row>
  </v-card>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    value: {
      default: () => null
    },
    imageUrl: {
      type: String,
      default: () => null
    },
    imageHeight: {
      type: String,
      default: () => "35"
    },
    imageWidth: {
      type: String,
      default: () => "35"
    },
    imageSize: {
      type: String,
      default: () => "35"
    }
  }
};
</script>
