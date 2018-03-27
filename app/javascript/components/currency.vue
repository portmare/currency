<template>
  <h2>{{ nom }} {{ locale }} ~ {{ rate }} руб.</h2>
</template>

<script>
  export default {
    props: ['locale', 'rate', 'nom']
  }
</script>
