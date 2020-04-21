import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

import arb.soundcipher.*; 
//import ddf.minim.*;

Capture cam;
CVImage img;

SCScore score = new SCScore();
float[] r = new float[4];
boolean sonido;

CascadeClassifier face;
String faceFile;
ArrayList<Pelota> pelotas;
boolean modo, rectangulo, rand,menu,time;
int puntuacion;

PShader edges;

SoundCipher sc = new SoundCipher(this);
void setup() {
  score.tempo(80);
  score.addCallbackListener(this);
  makeMusic();
  time=true;
  sonido=false;
  menu=true;
  rectangulo=true;
  puntuacion=0;
  rand=true;
  modo =true;
  size(640, 480,P2D);
  cam = new Capture(this, width , height);
  cam.start(); 
  
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  faceFile = "haarcascade_frontalface_default.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  
  pelotas=new ArrayList<Pelota> ();
  for(int i = 0; i<10;i++){
    generarPelotas();
  }  
  
  edges = loadShader("edges.glsl") ;
  edges.set("menu",menu);
}

void generarPelotas(){
  pelotas.add(new Pelota(random(45)+5,new float[]{random(255),random(255),random(255)},new float[]{random(10)-10,random(10)-10},new float[]{random(width),random(height)}));
}

void draw() {  
    
  if (cam.available()) {
    background(0);
    
    cam.read();
    
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    Mat gris = img.getGrey();
    image(img,0,0);
    
    shader(edges) ;
    FaceDetect(gris);
    
    if(modo){
      stroke(120);
      fill(120);
      rect(18, height-30, 100, 20, 7);
      fill(0);
      text("Puntuacion "+puntuacion, 20,height-20); 
    }
    if(menu){
      stroke(120);
      fill(120);
      rect(18, 20, 200, 110, 7);
      fill(255);
      text("Pulse espacio para salir del menu", 20,30);
      
      if(modo){
        String mostrar;
        text("Modo(e): juego", 20,45);
        if(rand)mostrar="renovar";
        else mostrar="eliminar";
        text("tratamiento(r): "+mostrar, 25,60);
        
      }else {
        text("Modo(e): rebote", 20,45);
      }
      text("Mostrar rectangulo facial(t)", 20,75);
      text("Para modificar los valores pulse\nla tecla entre parenteris", 20,90);
      text("Para parar la musica pusle m", 20,120);
    } else{
      moverPelotas();
      imprimirEsferas();
    }
    gris.release();
    shader(edges) ;
    if(time){
      edges.set("u_time",float(millis())/float(1000));
      edges.set("u_mouse",float(mouseX),float(mouseY));
    }
  }
}

void imprimirEsferas(){
  for(Pelota pelota: pelotas){
      fill(pelota.getColor());
      noStroke();
      float[] datos= pelota.getDatos();
      ellipse(datos[1],datos[2],datos[0],datos[0]);
    }
}

void moverPelotas(){
   for(Pelota pelota: pelotas){
     pelota.moverPelota();
   }
}

void FaceDetect(Mat grey)
{
  
  //Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  noFill();
  stroke(255,0,0);
  strokeWeight(2);
  
  for (Rect r : facesArr) {    
    if(rectangulo)rect(r.x, r.y, r.width, r.height);
    int i=0;
    ArrayList<Integer> eliminar =new ArrayList <Integer>();
    for(Pelota pelota:pelotas){
      if(pelota.comprobarColision(r.x, r.y, r.width, r.height) && modo) eliminar.add(i);
      i++;
    }
    if(!menu){
      int j=0;
      for(int elimino: eliminar){
        float datos[]=pelotas.get(elimino-j).getDatos();
        sc.instrument(datos[0]);
        sc.pan((int)(datos[1]/5.07));
        sc.playNote(datos[1]/5.07, datos[2]/3.78, 0.2);
        pelotas.remove(elimino-j);
        j++;
        if(rand){
          generarPelotas();
        }
      }
      if(i!=0)puntuacion+=100*j/i;
    }
   }
  
  faces.release();
}

void mousePressed(){
  if(!menu) pelotas.add(new Pelota(random(45)+5,new float[]{random(255),random(255),random(255)},new float[]{random(20)-10,random(20)-10},new float[]{mouseX,mouseY}));
 
}
 void keyPressed(){
   if(key==' '){
     menu=menu^true;
      edges.set("menu",menu);
   }
   if(key=='r'||key=='R'){
     rand=rand^true;
   }
   if(key=='e'|| key=='E'){
     modo=modo^true;
   }
   if(key=='1'){
     edges = loadShader("edges.glsl") ;
    edges.set("menu",menu);
    time=false;
   }
   if(key=='2'){
     edges = loadShader("edgesX.glsl") ;
  edges.set("menu",menu);
  time=false;
   }
   if(key=='3'){
     edges = loadShader("edgesY.glsl") ;
     edges.set("menu",menu);
     time=false;
   }
   if(key=='4'){
     edges = loadShader("suavisadoM.glsl") ;
     edges.set("menu",menu);
     time=false;
   }
   if(key=='5'){
      edges = loadShader("blurCara.glsl");
      edges.set("u_time",float(millis())/float(1000));
      edges.set("menu",menu);
      edges.set("u_mouse",float(mouseX),float(mouseY));
      time=true;
   }
   if(key=='6'){
      //edges = loadShader("suavisadoG.glsl");
      //edges.set("menu",menu);
   }
   if(key=='7'){
      resetShader();
   }
   
   if(key=='t'|| key=='t'){
     rectangulo=rectangulo^true;
   }
   if(key=='m'|| key=='M'){
     sonido=sonido^true;
     if(sonido)makeMusic();
     else {
       score.addCallback(4, 1);
       score.addCallback(1, 1);
       score.addCallback(2, 1);
       score.addCallback(3, 1);
       score.addCallback(0, 1);
     }
   }
   
 }
 
 void makeMusic() {
  score.empty();
  for (float i=0; i<16; i++) {
    if(!sonido)break;
      
    if (i%8 == 0 || i%16 == 14) {
      score.addNote(i/4, 9, 0, 36, 100, 0.25, 0.8, 64);
    } else if (random(10) < 1) score.addNote(i/4, 9, 0, 36, 70, 0.25, 0.8, 64);
    if (i%8 == 4) {
      score.addNote(i/4, 9, 0, 38, 100, 0.25, 0.8, 64);
    } else if (random(10) < 2) score.addNote(i/4, 9, 0, 38, 60, 0.25, 0.8, 64);
    if(random(10) < 8) {
      score.addNote(i/4, 9, 0, 42, random(40) + 70, 0.25, 0.8, 64);
    } else score.addNote(i/4, 9, 0, 46, 80, 0.25, 0.8, 64);
  }
  
  score.addCallback(4, 0);
  score.play();
  
}

void handleCallbacks(int callbackID) {
  switch (callbackID) {
    case 0:
      score.stop();
      makeMusic();
      break;
    case 1:
      score.stop();
      break;
  }
}

void stop() {
  score.stop();
}
