class Gene {

  int geneLength;
  int[] genotype;
  int value;
  
  Gene(int l) {
    geneLength = l;
    genotype = new int[geneLength];
    setValue();
  }
  
/*  Gene(Gene g) {
    geneLength = g.geneLength;
    genotype = g.genotype;
    value = g.value;
  }
*/

  void mutate() {
    int meow = (int)random(geneLength);
    genotype[meow] = abs(genotype[meow]-1);
  }
  
  void setValue() {
    int count = 0;
    int num = 0;
    for (int i = 0; i < geneLength; i++) {
      num = (int)random(2);
      genotype[i] = num;
      count += num * pow(2, geneLength - i - 1);  
    }
    value = count;
  }
  
}
