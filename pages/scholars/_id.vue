<template>
  <app-main-container>
    <template v-slot:title>{{ $route.params.id }}</template>

    User Detail
  </app-main-container>
</template>

<script>
export default {};
</script>

<style></style>
