import React from 'react';
import { SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { LineChartNativeComponent } from '@baykan/react-native-linechart-native';

function App(): JSX.Element {
  const count = 25;
  const range = 50;

  const count2 = 25;
  const range2 = 50;

  const values = Array.from({ length: count }, (_, i) => {
    const val = Math.floor(Math.random() * range) + 3;
    return { x: i, y: val };
  });

  // const values2 = Array.from({ length: count }, (_, i) => {
  //   const val = Math.floor(Math.random() * range) + 3;
  //   return { x: i, y: val };
  // });

  const lineData = {
    dataSets: [
      {
        values: values,
        drawVerticalHighlightIndicatorEnabled: true,
        drawValuesEnabled: false,
        mode: 'linear',
        drawHorizontalHighlightIndicatorEnabled: false,
        gradientColorsData: { from: '#ffffff', to: '#080707' },
        label: 'Chart1',
        limitLineEntity: {
          lineWidth: 2.0,
          lineColor: '#d6371e',
          lineDashLengths: [5, 2],
          labelPosition: 'leftTop',
          labelValueColor: '#d6371e',
          fontSize: 15,
          limit: 25,
        },
      },
    ],
  };

  return (
    <SafeAreaView style={styles.container}>
      <View
        style={{
          flex: 1,
          height: 550,
          justifyContent: 'center',
          alignItems: 'center',
        }}
      >
        <LineChartNativeComponent
          data={lineData}
          markerEntity={{
            color: '#161617',
            fontSize: 17,
            bgColor: '#ffffff',
            circleEntity: { size: 15, color: '#1e498f' },
            position: { left: 8, top: 0, bottom: 0, right: 8 },
          }}
          xAxisEntity={{
            drawLabelsEnabled: true,
            labelPosition: 'bottom',
            labelFont: { size: 15, weight: 'bold' },
            labelTextColor: '#080707',
            yOffset: 10,
            xOffset: 0,
          }}
          yAxisEntity={{
            drawLabelsEnabled: true,
            labelPosition: 'outside',
            labelFont: { size: 15, weight: 'bold' },
            labelTextColor: '#080707',
            xOffset: 0,
            yOffset: 0,
            axisMin: 0,
            axisMax: 120,
          }}
          animationEntity={{
            xAxisDuration: 0.8,
            xAxisEasing: 'linear',
            yAxisDuration: 1,
            yAxisEasing: 'linear',
          }}
          drawGridLinesEnabled={true}
          dragEnabled={true}
          style={{ width: '100%', height: 500, margin: 16 }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f4f6f8',
  },
});
export default App;
