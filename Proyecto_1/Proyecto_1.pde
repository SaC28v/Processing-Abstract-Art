//-----------------PROYECTO ARTE FRACTAL-------------------///
//REGLA No.1 -> Todos los elementos son aleatorios
//REGLA No.2 -> Todo el arte abstracto se crea utilizando el algoritmo de ruido (noise)
//REGLA No.3 -> Cada vez que se presiona una tecla, la forma de las estrellas cambia


//Variables Arte Abstracto
Puntos[] puntos;
HashMap<String, Integer> PaletaColor1;

//Variables Estrellas
int numLadosEstrella;
ArrayList<Estrella> estrellas;

void setup() {
  fullScreen();
  //size(1100,700);
  background(0);
  puntos = new Puntos[7000];

  PaletaColor1 = new HashMap<String, Integer>();
  PaletaColor1.put("color1",color(29,1,245));
  PaletaColor1.put("color2",color(0,50,245));
  PaletaColor1.put("color3",color(0,127,245));
  PaletaColor1.put("color4",color(109,0,245)); 
  PaletaColor1.put("color5",color(189,0,245));
  
  //Inicializacion de puntos del Arte Abstracto
  for(int i = 0; i < puntos.length; i++){
    puntos[i] = new Puntos();
  }
    
  numLadosEstrella = 4; // Valor inicial de aristas = 4
  //Inicializacion del arreglo dinamico
  estrellas = new ArrayList<Estrella>();
  
}

void draw() {
  translate(width / 2, height / 2);
  rectMode(CENTER);
  noFill(); 
  rect(0, 0, 1000, 600);
  
  //Funciones Arte Abstracto (Objeto_1)
  for(Puntos p : puntos) {
    p.mover();
    p.mostrar();
  }
  
  //Funciones Estrellas (Objeto_2)
  for (int i = 0; i<estrellas.size(); i++) {
    Estrella estrella = estrellas.get(i);
    estrella.animar();    
  }
}


//----------------------ARTE ABSTRACTO (NOISE)--------------------//
class Puntos{
  float angulo;
  PVector posicion;
  
  //variables para usar Paleta de Color
  String[] colores;
  String colorElegido;
  color particulaColor;

  public Puntos(){
    //REGLA No.1
    posicion = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2));
    angulo = 0;


    // Selecciona un color de la paleta utilizando un nombre
    //Creacion de Arreglo de Strings para las claves del HashMap
    colores = PaletaColor1.keySet().toArray(new String[0]);
    colorElegido = colores[int(random(colores.length))];
    particulaColor = PaletaColor1.get(colorElegido);
  }
  
  
  public void mover(){ 
    //REGLA No.2
    //--References Processing--
    //Investigacion complementaria (noise)
    angulo = noise(posicion.x / 100, posicion.y / 100) * TWO_PI;
    posicion.add(new PVector(cos(angulo) / TWO_PI, sin(angulo) / TWO_PI));
    
    if(posicion.y < -300 || posicion.y > 300 || posicion.x < -500 || posicion.x > 500){
      posicion = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2));
    }
  }

  public void mostrar(){
    stroke(particulaColor);
    point(posicion.x, posicion.y);
  }
}

//------------------------PARTICULAS ESTRELLAS--------------------//
class Estrella{
  float x, y, fuerzaX, fuerzaY, dirX, dirY, nX, nY, dim, transparencia;
  color colorEstrella;

  public Estrella(float x, float y) {
    this.x = x;
    this.y = y;
    this.fuerzaX = 0.5;
    this.fuerzaY = 0.5;
    this.dirX = random(-fuerzaX, fuerzaX);
    this.dirY = random(-fuerzaY, fuerzaY);
    this.nX = noise(x / 100.0, y / 100.0); //Efecto noise en estrellas
    this.nY = noise(y / 100.0, x / 100.0);
    this.dim = random(15, 25);
    this.transparencia = random(100,255);
    this.colorEstrella = color(255, 255, 0);
  }

  public void mover() {
    this.x += dirX;
    this.y += dirY;
    this.transparencia -= 10;
    this.dim -= 0.2;
    //map(value, inicio1, final1, inicio2, final2)
    this.dirX = map(nX, 0, 1, -fuerzaX, fuerzaX); //Maps son...
    this.dirY = map(nY, 0, 1, -fuerzaY, fuerzaY);
  }

  public void dibujar() {
    stroke(0);
    fill(colorEstrella);
    cambioDeForma(x, y, numLadosEstrella, dim / 2, dim);
  }

  public void animar() {
     if (transparencia <= 0 && dim <= 0) {
    return; // No hacemos nada si ya están completamente desvanecidas.
  }
    mover();
    dibujar();
  }
  
  //REGLA No.3
  //--References Processing--
  void cambioDeForma(float x, float y, int lados, float radio1, float radio2) {
    float angulo = TWO_PI / lados;
    float medioAngulo = angulo / 2.0;
    
    beginShape();
      for (float i = -PI/2; i < TWO_PI - PI/2; i += angulo) {
        float sx = x + cos(i) * radio2;
        float sy = y + sin(i) * radio2;
        vertex(sx, sy);
        sx = x + cos(i + medioAngulo) * radio1;
        sy = y + sin(i + medioAngulo) * radio1;
        vertex(sx, sy);
      }
    endShape(CLOSE);
  }
  
}

 
//--------------------INTERACTIVIDAD CON EL USUARIO----------------//

//Arte Abstracto
void mousePressed() { //Si se presiona click, todo el arte abstracto se resetea
  background(0);
  noiseSeed((long) random(100)); //valor aleatorio de duracion(tiempo)
  
  for(int i = 0; i < puntos.length; i++) {
    puntos[i] = new Puntos();
  }
}

//Estrellas
void keyPressed() { //Si se presiona barra espaciadora, se generan estrellas aleatoriamente
  if (keyCode == 32) {
    
    //REGLA No.1
    int numEstrellas = int(random(1, 10));
    for (int i = 0; i < numEstrellas; i++) {
      float posX = random(-width / 2, width / 2); // Distribución en todo el ancho
      float posY = random(-height / 2, height / 2); // Distribución en todo el alto
      
      Estrella nuevaEstrella = new Estrella(posX, posY);
      estrellas.add(nuevaEstrella);
    }
  } 
  
//REGLA No.3
  else if (key >= '4' && key <= '9') {//Si se presiona los numeros de 4 a 9, la forma de estrella cambia
    numLadosEstrella = key - '0'; // Convierte el carácter a un número
  }
}
