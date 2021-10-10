<template>
  <v-card outlined min-height="70">
    <v-card-text>
      <div class="d-flex justify-center align-center">
        <slot name="image">
          <v-img
            :src="imageUrl"
            :max-height="imageSize || imageHeight"
            :max-width="imageSize || imageWidth"
            :class="{
              'rounded-circle': imageRounded
            }"
          />
        </slot>
        <div class="title mx-3 white--text">
          <slot>
            <span v-text="value" />
          </slot>
        </div>
      </div>
      <div class="text-center mt-5">
        <div class="subtitle-1 white--text" v-text="title" />
      </div>
    </v-card-text>
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
      type: [String, Number],
      default: () => null
    },

    imageRounded: Boolean,

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
