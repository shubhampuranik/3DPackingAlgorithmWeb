package mylogic;

import mylogic.Cuboid;
import mylogic.Order;
import mylogic.OrderIdComparator;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Shantanu on 22-06-2017.
 */
public class Item {
    public long id,orderId;
    public String name;
    public double length,breadth,height,weight;
    public boolean isFragile,thisSideUp;
    public static Connection connection;
    static {
        try{
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5433/test", "postgres", "lguru");
        }catch(Exception e)
        {

        }
    }


    public static Item getItem(String name){
        Item item=new Item();
        try {
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("select * from items where name='" + name + "';");
            while (resultSet.next()) {
                item.id=resultSet.getLong("id");
                item.name=resultSet.getString("name");
                item.length=resultSet.getDouble("length");
                item.breadth=resultSet.getDouble("breadth");
                item.height=resultSet.getDouble("height");
                item.weight=resultSet.getDouble("weight");
                item.isFragile=resultSet.getBoolean("is_fragile");
                item.thisSideUp=resultSet.getBoolean("this_side_up");
            }
        }catch (Exception e)
        {
            System.out.println(e);
            return null;
        }
        return item;
    }

    public static ArrayList<Cuboid> getCuboids(List<Order> orders){
        ArrayList<Cuboid> cuboids=new ArrayList<>();
        for(Order o:orders){
            Item item=Item.getItem(o.itemName);
            long qty=o.itemQuantity;
//            System.out.println(item.name);
            Cuboid cuboid=new Cuboid(o.orderId,item.length,item.breadth,item.height,item.weight,item.isFragile,item.thisSideUp);
            for(long i=0;i<qty;i++){
                Cuboid c=new Cuboid(cuboid);
                cuboids.add(c);
//                System.out.println("method-"+cuboid);
            }
        }
//        Collections.sort(cuboids,new OrderIdComparator());
        return cuboids;
    }
}
