<template>
  <v-card id="billing" ref="billing" outlined>
    <v-card-title>Billing</v-card-title>
    <v-divider></v-divider>
    <v-card-text class="d-flex justify-space-around align-center pa-10">
      <app-plan-preview-card
        title="Free Tier"
        subtitle="Details coming soon"
        emoji="💡"
      />

      <app-plan-preview-card
        title="Basic"
        subtitle="Details coming soon"
        emoji="🍕"
      />

      <app-plan-preview-card
        title="Premium"
        subtitle="Details coming soon"
        emoji="👑"
      />
    </v-card-text>
  </v-card>
</template>

<script>
export default {};
</script>

<style></style>
