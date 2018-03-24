<template>
  <h2>{{ nomination }} {{ locale }} ~ {{ rate }} руб.</h2>
</template>

<script>
  export default {
    props: ['locale', 'rate', 'nomination']
  }
</script>
