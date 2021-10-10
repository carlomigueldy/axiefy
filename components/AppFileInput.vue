<template>
  <div @click="select" style="display: table; cursor: pointer;">
    <slot> </slot>

    <input
      type="file"
      ref="input"
      style="display: none"
      @change="onChange"
      :accept="accept"
      :multiple="multiple"
    />
  </div>
</template>

<script>
export default {
  props: {
    accept: {
      type: String,
      default: () => "image/*"
    },

    multiple: Boolean
  },

  methods: {
    select() {
      console.log("select");

      this.$refs.input.click();
    },

    onChange(event) {
      console.log("onChange", event, event.target.files);

      if (!this.multiple) {
        const [file] = event.target.files;
        const preview = URL.createObjectURL(file);

        return this.$emit("change", { file, preview, files: [], previews: [] });
      }

      const previews = [];
      for (const file of event.target.files) {
        previews.push(URL.createObjectURL(file));
      }

      this.$emit("change", {
        file: null,
        preview: null,
        files: event.target.files,
        previews
      });
    }
  }
};
</script>

<style></style>
