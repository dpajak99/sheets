void main() {
  int a = 23;
  int b = 5;

  int missing = missingToBeDivisible(a, b);
  print(missing);
}
int missingToBeDivisible(int a, int b) {
  int remainder = a % b;
  return remainder == 0 ? 0 : b - remainder;
}