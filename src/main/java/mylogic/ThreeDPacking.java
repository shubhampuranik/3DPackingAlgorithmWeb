package mylogic;

import javax.xml.transform.sax.SAXSource;
import java.util.*;

/**
 * Created by LG-2 on 6/6/2017.
 */
public class ThreeDPacking {
    public ArrayList<Point> list,midPoints;
    public ArrayList<Rectangle> fragileRects,topFaces;
    public Cuboid bin;
    public double capacity;
    public void addAllPoints(Cuboid c){
        Point midPoint=new Point((c.topLeftRear.x+c.topRightRear.x)/2,c.topLeftRear.y,(c.topLeftRear.z+c.topLeftFront.z)/2);
        midPoints.add(midPoint);
        Rectangle rectangle=new Rectangle(c.length,c.breadth);
        rectangle.setTopLeft(new Point2D(c.topLeftRear.x,c.topLeftRear.z));
        topFaces.add(rectangle);
        for(double z=c.bottomLeftRear.z;z<=c.bottomLeftFront.z;z++)
            list.add(new Point(c.bottomRightRear.x,c.bottomRightRear.y,z));
        for(double x=c.bottomLeftRear.x;x<c.bottomRightRear.x;x++)
            list.add(new Point(x,c.bottomLeftFront.y,c.bottomLeftFront.z));
        if(!c.isFragile){
            for(double x=c.topLeftRear.x;x<=c.topRightRear.x;x++)
                list.add(new Point(x,c.topLeftRear.y,c.topLeftRear.z));
            for(double z=c.topLeftRear.z;z<c.topRightFront.z;z++)
                list.add(new Point(c.topLeftRear.x,c.topLeftRear.y,z));
        }else {
            fragileRects.add(new Rectangle(new Point2D(c.topLeftRear.x,c.topLeftRear.z),c.length,c.breadth));
            c.color=new float[]{0f,1f,0f};
        }
//        Collections.sort(list,new YZXComparator());
//        Collections.sort(list,new XZYComparator());
        Collections.sort(list,new ZYXComparator());
        System.out.println("add "+c);

    }
    public ArrayList<Cuboid> fitCuboids(double length,double breadth,double height,double weight,ArrayList<Cuboid> cuboids){
        capacity=weight;
        midPoints=new ArrayList<Point>();
        fragileRects=new ArrayList<Rectangle>();
        topFaces=new ArrayList<Rectangle>();
        ArrayList<Cuboid> fitCuboids=new ArrayList<Cuboid>();
        Cuboid c=cuboids.get(0);
        c.setBottomLeftRear(new Point(0.0, 0.0, 0.0));
        System.out.println("1st Cuboid "+c);
        fitCuboids.add(c);
        System.out.println("FIT:-"+fitCuboids);
        list=new ArrayList<Point>();
        for(double x=c.bottomRightRear.x;x<=length;x++)
            list.add(new Point(x,0.0,0.0));
        for(double z=c.bottomLeftFront.z;z<=breadth;z++)
            list.add(new Point(0.0,0.0,z));
        addAllPoints(c);                                
//        fitCuboids.add(c);
        for(int i=1;i<cuboids.size();i++) {
            c = cuboids.get(i);
            System.out.println("Selected Cuboid:- "+c);
            if (capacity >= capacity - c.weight) {
                if (!c.thisSideUp) {
                    if (c.length > c.height && c.breadth > c.height) {
                        if (c.length > c.breadth)
                            c.rotateHeightBreadth();
                        else
                            c.rotateLengthHeight();
                    }
                }
                for (int j = 0; j < list.size(); j++) {
                    Point p = list.get(j);
                    c.setBottomLeftRear(p);
                    Rectangle bottomFace = new Rectangle(new Point2D(c.bottomLeftRear.x, c.bottomLeftRear.z), c.length, c.breadth);
                    if (!bottomFace.intersects(fragileRects)) {
                        if (c.bottomLeftRear.y > 0.0) {
//                            System.out.println(p + " " + c.contains1(fitCuboids) + " " + c.containsAllCornerPoints(fitCuboids) + " " + !c.intersects(fitCuboids));
                            if (c.contains1(fitCuboids) && c.containsAllCornerPoints(fitCuboids) && !c.intersects(fitCuboids) && p.x + c.length <= length && p.x + c.length >= 0 && p.y + c.height <= height && p.y + c.height >= 0 && p.z + c.breadth <= breadth && p.z + c.breadth >= 0) {
                                fitCuboids.add(c);
                                addAllPoints(c);
                                capacity=capacity-c.weight;
//                                System.out.println("Cuboid:- "+c+" Point:-"+p);
                                break;
                            } else {
                                c.reset();
                                c.rotateLengthBreadth();
                                c.setBottomLeftRear(p);
                                if (c.contains1(fitCuboids) && c.containsAllCornerPoints(fitCuboids) && !c.intersects(fitCuboids) && p.x + c.length <= length && p.x + c.length >= 0 && p.y + c.height <= height && p.y + c.height >= 0 && p.z + c.breadth <= breadth && p.z + c.breadth >= 0) {
                                    fitCuboids.add(c);
                                    addAllPoints(c);
                                    capacity=capacity-c.weight;
//                                    System.out.println("Cuboid:- "+c+" Point:-"+p);
                                    break;
                                }
                            }
                        } else {
                            if (!c.intersects(fitCuboids) && p.x + c.length <= length && p.x + c.length >= 0 && p.y + c.height <= height && p.y + c.height >= 0 && p.z + c.breadth <= breadth && p.z + c.breadth >= 0) {
                                fitCuboids.add(c);
                                addAllPoints(c);
                                capacity=capacity-c.weight;
//                                System.out.println("Cuboid:- "+c+" Point:-"+p);
                                break;
                            } else {
                                c.reset();
                                c.rotateLengthBreadth();
                                c.setBottomLeftRear(p);
                                if (!c.intersects(fitCuboids) && p.x + c.length <= length && p.x + c.length >= 0 && p.y + c.height <= height && p.y + c.height >= 0 && p.z + c.breadth <= breadth && p.z + c.breadth >= 0) {
                                    fitCuboids.add(c);
                                    addAllPoints(c);
                                    capacity=capacity-c.weight;
//                                    System.out.println("Cuboid:- "+c+" Point:-"+p);
                                    break;
                                }
                            }
                        }
                    }
                }

            }

        }
        ArrayList<Cuboid> fitCuboids1=new ArrayList<>();
        c=new Cuboid(length,breadth,height,weight);
        c.setBottomLeftRear(new Point(0.0,0.0,0.0));
        fitCuboids1.add(c);
        fitCuboids1.addAll(fitCuboids);
        System.out.println(fitCuboids);
        return fitCuboids1;
    }
    public static void main(String[] args) {
        Random r=new Random();//This is for random generation of cuboids
        ArrayList<Cuboid> cuboids=new ArrayList<>();
        for(int i=0;i<50;i++)
            cuboids.add(new Cuboid((r.nextInt(5)+1)*20,(r.nextInt(5)+1)*20,(r.nextInt(5)+1)*20,((r.nextInt(5)+1)*20)*((r.nextInt(10)+1)*20)));
        ThreeDPacking packing=new ThreeDPacking();
        System.out.println(packing.fitCuboids(500, 500, 500, 5,cuboids));
    }
}
