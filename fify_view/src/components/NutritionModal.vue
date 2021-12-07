<template>
    <transition name="modal">
        <div class="modal-mask">
        <div class="modal-wrapper">
            <div class="modal-container">
            
            <div class="modal-head">
                <slot name="head">
                    Head
                </slot>
            </div>

            <div class="modal-body">
                <slot name="body">
                    Body
                </slot>
            </div>

            </div>
        </div>
        </div>
    </transition>
</template>

<script>
export default {
  name: "NutritionModal",
  data() {
    return {
      show: false
    };
  },
  methods: {
    closeModal() {
      this.show = false;
      document.querySelector("body").classList.remove("overflow-hidden");
    },
    openModal() {
      this.show = true;
      document.querySelector("body").classList.add("overflow-hidden");
    }
  }
};
</script>


