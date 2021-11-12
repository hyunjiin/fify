<template>
    <div class="mb-10">
        <page-title icon="mdi-video" class="mb-3">보안 카메라</page-title>
        <m-title>실시간 카메라</m-title> 
        <remote-camera url="https://picsum.photos/seed/picsum/640/480" 
            max-width="640"></remote-camera>
    </div>
</template>

<script>
export default {
    name: 'Camera1',
    data() {
        return {
        };
    },
};
</script>

<style scoped>
</style>
