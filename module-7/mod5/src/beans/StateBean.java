package beans;

import java.sql.*;
import java.util.ArrayList;

public class StateBean {

    private int stateId;
    private String stateName;
    private String abbreviation;
    private String capital;
    private int population;
    private String region;

    private final String url = "jdbc:mysql://localhost:3306/CSD430";
    private final String username = "student1";
    private final String password = "pass";

    public ArrayList<Integer> getStateIds() {
        ArrayList<Integer> ids = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            String sql = "SELECT state_id FROM rashaistatesdata ORDER BY state_id";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ids.add(rs.getInt("state_id"));
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ids;
    }

    public void getStateById(int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            String sql = "SELECT * FROM rashaistatesdata WHERE state_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stateId = rs.getInt("state_id");
                stateName = rs.getString("state_name");
                abbreviation = rs.getString("abbreviation");
                capital = rs.getString("capital");
                population = rs.getInt("population");
                region = rs.getString("region");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getStateId() {
        return stateId;
    }

    public String getStateName() {
        return stateName;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public String getCapital() {
        return capital;
    }

    public int getPopulation() {
        return population;
    }

    public String getRegion() {
        return region;
    }
}