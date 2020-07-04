<template>
  <div>
    <!-- <div id="echartsDemo" style="width: 500px;height: 500px;"></div> -->
    <div id="echartsBarDemo" style="width: 500px;height: 25vh;"></div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      content: "",
    };
  },
  mounted() {
    this.drawBar();
  },
  methods: {
    rgba() {
      let r = Math.floor(Math.random() * 255);
      let g = Math.floor(Math.random() * 255);
      let b = Math.floor(Math.random() * 255);
      let a = Math.floor(Math.random() * 10);
      return `rgb(${r},${g},${b},${a})`;
    },
    drawBar() {
      let echartsBarDemo = this.$echarts.init(
        document.getElementById("echartsBarDemo")
      );
      echartsBarDemo.setOption({
        // backgroundColor: "#2c343c",
        tooltip: {
          trigger: "item",
          formatter: "{a} <br/>{b}: {c} ({d}%)",
        },
        legend: {
          orient: "vertical",
          left: 10,
          data: [
            "Vue",
            "Typescript",
            "Nest",
            "Javascript",
            "Bootstap",
            "ElementUi",
          ],
        },
        series: [
          {
            name: "使用语言",
            type: "pie",
            radius: ["50%", "70%"],
            avoidLabelOverlap: true,
            label: {
              show: false,
              position: "center",
            },
            emphasis: {
              label: {
                show: true,
                fontSize: "30",
                fontWeight: "bold",
              },
            },
            labelLine: {
              show: true,
            },
            data: [
              { value: 746, name: "Vue" },
              { value: 923, name: "Typescript" },
              { value: 750, name: "Nest" },
              { value: 135, name: "Javascript" },
              { value: 234, name: "Bootstap" },
              { value: 620, name: "ElementUi" },
            ],
          },
        ],
      });
    },
  },
};
</script>
