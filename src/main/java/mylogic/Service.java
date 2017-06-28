package mylogic;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Created by Shantanu on 22-06-2017.
 */
public class Service {

    public static ArrayList<Cuboid> getResult(String json ){
//        String 
//        json="{\"vehicleName\":\"Medium Truck\",\"orders\":[{\"orderId\":1,\"itemName\":\"TV\",\"itemQuantity\":\"2\"},{\"orderId\":2,\"itemName\":\"Fridge\",\"itemQuantity\":\"2\"},{\"orderId\":2,\"itemName\":\"Mobile\",\"itemQuantity\":\"3\"},{\"orderId\":3,\"itemName\":\"Washing Machine\",\"itemQuantity\":\"2\"}]}";
        Gson gson=new Gson();
        Orders orders=gson.fromJson(json,Orders.class);
        System.out.println(orders);
        Vehicle vehicle=Vehicle.getVehicle(orders.vehicleName);
        Cuboid bin=new Cuboid(vehicle.length,vehicle.breadth,vehicle.height,vehicle.capacity);
        ThreeDPacking packing=new ThreeDPacking();
        ArrayList<Cuboid> cuboids=Item.getCuboids(orders.orders);
        ArrayList<Cuboid> drawCuboids=packing.fitCuboids(bin.length,bin.breadth,bin.height, bin.weight,cuboids);
//        System.out.println(cuboids);
//        System.out.println(drawCuboids);
//        RotationExample3D.runThis(cuboids);
        return drawCuboids;
    }

    public static void main(String[] args) {
        getResult(null);
//        String json="{\"vehicleName\":\"Medium Truck\",\"orders\":[{\"orderId\":1,\"itemName\":\"TV\",\"itemQuantity\":\"2\"},{\"orderId\":2,\"itemName\":\"Fridge\",\"itemQuantity\":\"2\"},{\"orderId\":2,\"itemName\":\"Mobile\",\"itemQuantity\":\"3\"},{\"orderId\":3,\"itemName\":\"Washing Machine\",\"itemQuantity\":\"2\"}]}";
//        Gson gson=new Gson();
//        Orders orders=gson.fromJson(json,Orders.class);
//        System.out.println(orders);
//        Vehicle vehicle=Vehicle.getVehicle(orders.vehicleName);
//        Cuboid bin=new Cuboid(vehicle.length,vehicle.breadth,vehicle.height,vehicle.capacity);
//        ThreeDPacking packing=new ThreeDPacking();
//        ArrayList<Cuboid> cuboids=Item.getCuboids(orders.orders);
//        System.out.println("BIN= "+bin);
//        ArrayList<Cuboid> drawCuboids=packing.fitCuboids(bin.length,bin.breadth,bin.height, bin.weight,cuboids);
//        System.out.println(cuboids);
//        System.out.println(drawCuboids);
//        for(Cuboid c:cuboids)
//        {
////            System.out.println("id="+c.id+" Point="+c.bottomLeftRear);
//            System.out.println("c="+c);
//        }
    }
}
