<template>
  <h3>{{ nom }} {{ locale }} ~ {{ rate }} руб.</h3>
</template>

<script>
  export default {
    props: ['locale', 'rate', 'nom']
  }
</script>
