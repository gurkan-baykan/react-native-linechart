/**
 * @type {import('@react-native-community/cli-types').UserDependencyConfig}
 */
module.exports = {
  dependency: {
    platforms: {
      android: {
        cmakeListsPath: "build/android/generated/source/codegen/jni/CMakeLists.txt",
      },
    },
  },
};
