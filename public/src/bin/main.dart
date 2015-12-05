import 'dart:html';

final CanvasElement canvas = querySelector('#canvas');
final CanvasRenderingContext2D ctx = canvas.context2D;
final int width = canvas.width = window.innerWidth;
final int height = canvas.height = window.innerHeight;

void main() {
  window.animationFrame.then(render);
}

void render(double now) {
  ctx.clearRect(0, 0, width, height);

  ctx.beginPath();
  ctx.setStrokeColorRgb(255, 0, 0);
  ctx.lineWidth = 5;
  ctx.moveTo(0, 0);
  ctx.lineTo(width, height);
  ctx.stroke();

  window.animationFrame.then(render);
}
