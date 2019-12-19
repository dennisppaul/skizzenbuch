package de.hfkbremen.mesh.sandbox;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class LuxRenderCyHairFile {

    public static final int CY_HAIR_FILE_SEGMENTS_BIT = 1;
    public static final int CY_HAIR_FILE_POINTS_BIT = 2;
    public static final int CY_HAIR_FILE_THICKNESS_BIT = 4;
    public static final int CY_HAIR_FILE_TRANSPARENCY_BIT = 8;
    public static final int CY_HAIR_FILE_COLORS_BIT = 16;

    public static final int CY_HAIR_FILE_INFO_SIZE = 88;

    // File read errors
    public static final int CY_HAIR_FILE_ERROR_CANT_OPEN_FILE = -1;
    public static final int CY_HAIR_FILE_ERROR_CANT_READ_HEADER = -2;
    public static final int CY_HAIR_FILE_ERROR_WRONG_SIGNATURE = -3;
    public static final int CY_HAIR_FILE_ERROR_READING_SEGMENTS = -4;
    public static final int CY_HAIR_FILE_ERROR_READING_POINTS = -5;
    public static final int CY_HAIR_FILE_ERROR_READING_THICKNESS = -6;
    public static final int CY_HAIR_FILE_ERROR_READING_TRANSPARENCY = -7;
    public static final int CY_HAIR_FILE_ERROR_READING_COLORS = -8;

    cyHairFileHeader header;
    short[] segments;
    float[] points;
    float[] thickness;
    float[] transparency;
    float[] colors;

    public LuxRenderCyHairFile() {
        initialize();
    }

    cyHairFileHeader GetHeader() {
        return header;
    }        ///< Use this method to access header data.

    short[] GetSegmentsArray() {
        return segments;
    }    ///< Returns segments array (segment count for each hair strand).

    float[] GetPointsArray() {
        return points;
    }                ///< Returns points array (xyz coordinates of each hair point).

    float[] GetThicknessArray() {
        return thickness;
    }        ///< Returns thickness array (thickness at each hair point}.

    float[] GetTransparencyArray() {
        return transparency;
    }    ///< Returns transparency array (transparency at each hair point).

    float[] GetColorsArray() {
        return colors;
    }                ///< Returns colors array (rgb color at each hair point).

    private void initialize() {
        header.signature[0] = 'H';
        header.signature[1] = 'A';
        header.signature[2] = 'I';
        header.signature[3] = 'R';
        header.hair_count = 0;
        header.point_count = 0;
        header.arrays = 0;    // no arrays
        header.d_segments = 0;
        header.d_thickness = 1.0f;
        header.d_transparency = 0.0f;
        header.d_color[0] = 1.0f;
        header.d_color[1] = 1.0f;
        header.d_color[2] = 1.0f;
        //        memset( header.info, '\0', CY_HAIR_FILE_INFO_SIZE );
    }

    /// Sets the hair count, re-allocates segments array if necessary.
    void SetHairCount(int count) {
        header.hair_count = count;
        if (segments == null) {
            segments = new short[header.hair_count];
        }
    }

    // Sets the point count, re-allocates points, thickness, transparency, and colors arrays if necessary.
    void SetPointCount(int count) {
        header.point_count = count;
        if (points == null) {
            points = new float[header.point_count * 3];
        }
        if (thickness == null) {
            thickness = new float[header.point_count];
        }
        if (transparency == null) {
            transparency = new float[header.point_count];
        }
        if (colors == null) {
            colors = new float[header.point_count * 3];
        }
    }

    /// Sets default number of segments for all hair strands, which is used if segments array does not exist.
    void SetDefaultSegmentCount(int s) {
        header.d_segments = s;
    }

    /// Sets default hair strand thickness, which is used if thickness array does not exist.
    void SetDefaultThickness(float t) {
        header.d_thickness = t;
    }

    //    /// Use this function to allocate/delete arrays.
    //    /// Before you call this method set hair count and point count.
    //    /// Note that a valid HAIR file should always have points array.
    //    void SetArrays( int array_types )
    //    {
    //        header.arrays = array_types;
    //        if ( header.arrays & CY_HAIR_FILE_SEGMENTS_BIT && !segments ) segments = new short[header.hair_count];
    //        if ( ! (header.arrays & CY_HAIR_FILE_SEGMENTS_BIT) && segments ) { delete [] segments; segments=null; }
    //        if ( header.arrays & CY_HAIR_FILE_POINTS_BIT && !points ) points = new float[header.point_count*3];
    //        if ( ! (header.arrays & CY_HAIR_FILE_POINTS_BIT) && points ) { delete [] points; points=null; }
    //        if ( header.arrays & CY_HAIR_FILE_THICKNESS_BIT && !thickness ) thickness = new float[header.point_count];
    //        if ( ! (header.arrays & CY_HAIR_FILE_THICKNESS_BIT) && thickness ) { delete [] thickness; thickness=null; }
    //        if ( header.arrays & CY_HAIR_FILE_TRANSPARENCY_BIT && !transparency ) transparency = new float[header.point_count];
    //        if ( ! (header.arrays & CY_HAIR_FILE_TRANSPARENCY_BIT) && transparency ) { delete [] transparency; transparency=null; }
    //        if ( header.arrays & CY_HAIR_FILE_COLORS_BIT && !colors ) colors = new float[header.point_count*3];
    //        if ( ! (header.arrays & CY_HAIR_FILE_COLORS_BIT) && colors ) { delete [] colors; colors=null; }
    //    }

    /// Sets default hair strand transparency, which is used if transparency array does not exist.
    void SetDefaultTransparency(float t) {
        header.d_transparency = t;
    }

    /// Sets default hair color, which is used if color array does not exist.
    void SetDefaultColor(float r, float g, float b) {
        header.d_color[0] = r;
        header.d_color[1] = g;
        header.d_color[2] = b;
    }

    /// Hair file header
    static class cyHairFileHeader {

        char[] signature = new char[4];    ///< This should be "HAIR"
        int hair_count;        ///< number of hair strands
        int point_count;    ///< total number of points of all strands
        int arrays;            ///< bit array of data in the file

        int d_segments;        ///< default number of segments of each strand
        float d_thickness;    ///< default thickness of hair strands
        float d_transparency;    ///< default transparency of hair strands
        float[] d_color = new float[3];        ///< default color of hair strands

        char[] info = new char[CY_HAIR_FILE_INFO_SIZE];    ///< information about the file
    }

    public static void main(String[] args) {
        final Path path = Paths.get("/Users/dennisppaul/Downloads/cyHair/straight.hair");
        try {
            byte[] data = Files.readAllBytes(path);
            System.out.println(data.length);

            byte[] part1 = new byte[128];
            byte[] part2 = new byte[data.length-part1.length];

            System.arraycopy(data, 0, part1, 0, part1.length);
            System.arraycopy(data, part1.length, part2, 0, part2.length);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /*
    /// Loads hair data from the given HAIR file.
    int LoadFromFile( final String filename )
    {
        initialize();

        FILE *fp;
        fp = fopen( filename, "rb" );
        if ( fp == null ) return CY_HAIR_FILE_ERROR_CANT_OPEN_FILE;

        // read the header
        size_t headread = fread( &header, sizeof(cyHairFileHeader), 1, fp );

        //#define _CY_FAILED_RETURN(errorno) { Initialize(); fclose( fp ); return errorno; }


        // Check if header is correctly read
        if ( headread < 1 ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_CANT_READ_HEADER);

        // Check if this is a hair file
        if ( strncmp( header.signature, "HAIR", 4) != 0 ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_WRONG_SIGNATURE);

        // Read segments array
        if ( header.arrays & CY_HAIR_FILE_SEGMENTS_BIT ) {
            segments = new short[ header.hair_count ];
            size_t readcount = fread( segments, sizeof(short), header.hair_count, fp );
            if ( readcount < header.hair_count ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_READING_SEGMENTS);
        }

        // Read points array
        if ( header.arrays & CY_HAIR_FILE_POINTS_BIT ) {
            points = new float[ header.point_count*3 ];
            size_t readcount = fread( points, sizeof(float), header.point_count*3, fp );
            if ( readcount < header.point_count*3 ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_READING_POINTS);
        }

        // Read thickness array
        if ( header.arrays & CY_HAIR_FILE_THICKNESS_BIT ) {
            thickness = new float[ header.point_count ];
            size_t readcount = fread( thickness, sizeof(float), header.point_count, fp );
            if ( readcount < header.point_count ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_READING_THICKNESS);
        }

        // Read thickness array
        if ( header.arrays & CY_HAIR_FILE_TRANSPARENCY_BIT ) {
            transparency = new float[ header.point_count ];
            size_t readcount = fread( transparency, sizeof(float), header.point_count, fp );
            if ( readcount < header.point_count ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_READING_TRANSPARENCY);
        }

        // Read colors array
        if ( header.arrays & CY_HAIR_FILE_COLORS_BIT ) {
            colors = new float[ header.point_count*3 ];
            size_t readcount = fread( colors, sizeof(float), header.point_count*3, fp );
            if ( readcount < header.point_count*3 ) _CY_FAILED_RETURN(CY_HAIR_FILE_ERROR_READING_COLORS);
        }

        fclose( fp );

        return header.hair_count;
    }

    /// Saves hair data to the given HAIR file.
    int SaveToFile( final String filename ) final
    {
        FILE *fp;
        fp = fopen( filename, "wb" );
        if ( fp == null ) return -1;

        // Write header
        fwrite( &header, sizeof(cyHairFileHeader), 1, fp );

        // Write arrays
        if ( header.arrays & CY_HAIR_FILE_POINTS_BIT ) fwrite( points, sizeof(float), header.point_count*3, fp );
        if ( header.arrays & CY_HAIR_FILE_THICKNESS_BIT ) fwrite( thickness, sizeof(float), header.point_count, fp );
        if ( header.arrays & CY_HAIR_FILE_TRANSPARENCY_BIT ) fwrite( transparency, sizeof(float), header.point_count, fp );
        if ( header.arrays & CY_HAIR_FILE_COLORS_BIT ) fwrite( colors, sizeof(float), header.point_count*3, fp );

        fclose( fp );

        return header.hair_count;
    }
*/
/*
    //////////////////////////////////////////////////////////////////////////
    ///@name Other Methods

    /// Fills the given direction array with normalized directions using the points array.
    /// Call this function if you need strand directions for shading.
    /// The given array dir should be allocated as an array of size 3 times point count.
    /// Returns point count, returns zero if fails.
    int FillDirectionArray( float[] dir )
    {
        if ( dir==null || header.point_count<=0 || points==null ) return 0;

        int p = 0;	// point index
        for ( int i=0; i<header.hair_count; i++ ) {
        int s = (segments!=null) ? segments[i] : header.d_segments;
        if ( s > 1 ) {
            // direction at point1
            float len0, len1;
            ComputeDirection( &dir[(p+1)*3], len0, len1, &points[p*3], &points[(p+1)*3], &points[(p+2)*3] );

            // direction at point0
            float[] d0 = new float[3];
            d0[0] = points[(p+1)*3]   - dir[(p+1)*3]  *len0*0.3333f - points[p*3];
            d0[1] = points[(p+1)*3+1] - dir[(p+1)*3+1]*len0*0.3333f - points[p*3+1];
            d0[2] = points[(p+1)*3+2] - dir[(p+1)*3+2]*len0*0.3333f - points[p*3+2];
            float d0lensq = d0[0]*d0[0] + d0[1]*d0[1] + d0[2]*d0[2];
            float d0len = ( d0lensq > 0 ) ? (float) Math.sqrt(d0lensq) : 1.0f;
            dir[p*3]   = d0[0] / d0len;
            dir[p*3+1] = d0[1] / d0len;
            dir[p*3+2] = d0[2] / d0len;

            // We computed the first 2 points
            p += 2;

            // Compute the direction for the rest
            for ( int t=2; t<s; t++, p++ ) {
                ComputeDirection( &dir[p*3], len0, len1, &points[(p-1)*3], &points[p*3], &points[(p+1)*3] );
            }

            // direction at the last point
            d0[0] = - points[(p-1)*3]   + dir[(p-1)*3]  *len1*0.3333f + points[p*3];
            d0[1] = - points[(p-1)*3+1] + dir[(p-1)*3+1]*len1*0.3333f + points[p*3+1];
            d0[2] = - points[(p-1)*3+2] + dir[(p-1)*3+2]*len1*0.3333f + points[p*3+2];
            d0lensq = d0[0]*d0[0] + d0[1]*d0[1] + d0[2]*d0[2];
            d0len = ( d0lensq > 0 ) ? (float) Math.sqrt(d0lensq) : 1.0f;
            dir[p*3]   = d0[0] / d0len;
            dir[p*3+1] = d0[1] / d0len;
            dir[p*3+2] = d0[2] / d0len;
            p++;

        } else if ( s > 0 ) {
            // if it has a single segment
            float[] d0 = new float[3];
            d0[0] = points[(p+1)*3]   - points[p*3];
            d0[1] = points[(p+1)*3+1] - points[p*3+1];
            d0[2] = points[(p+1)*3+2] - points[p*3+2];
            float d0lensq = d0[0]*d0[0] + d0[1]*d0[1] + d0[2]*d0[2];
            float d0len = ( d0lensq > 0 ) ? (float) Math.sqrt(d0lensq) : 1.0f;
            dir[p*3]   = d0[0] / d0len;
            dir[p*3+1] = d0[1] / d0len;
            dir[p*3+2] = d0[2] / d0len;
            dir[(p+1)*3]   = dir[p*3];
            dir[(p+1)*3+1] = dir[p*3+1];
            dir[(p+1)*3+2] = dir[p*3+2];
            p += 2;
        }
    }
        return p;
    }

    // Given point before (p0) and after (p2), computes the direction (d) at p1.
    float ComputeDirection( float[] d, float &d0len, float &d1len, final float[] p0, final float[] p1, final float[] p2 )
    {
        // line from p0 to p1
        float[] d0 = new float[3];
        d0[0] = p1[0] - p0[0];
        d0[1] = p1[1] - p0[1];
        d0[2] = p1[2] - p0[2];
        float d0lensq = d0[0]*d0[0] + d0[1]*d0[1] + d0[2]*d0[2];
        d0len = ( d0lensq > 0 ) ? (float) Math.sqrt(d0lensq) : 1.0f;

        // line from p1 to p2
        float[] d1 = new float[3];
        d1[0] = p2[0] - p1[0];
        d1[1] = p2[1] - p1[1];
        d1[2] = p2[2] - p1[2];
        float d1lensq = d1[0]*d1[0] + d1[1]*d1[1] + d1[2]*d1[2];
        d1len = ( d1lensq > 0 ) ? (float) Math.sqrt(d1lensq) : 1.0f;

        // make sure that d0 and d1 has the same length
        d0[0] *= d1len / d0len;
        d0[1] *= d1len / d0len;
        d0[2] *= d1len / d0len;

        // direction at p1
        d[0] = d0[0] + d1[0];
        d[1] = d0[1] + d1[1];
        d[2] = d0[2] + d1[2];
        float dlensq = d[0]*d[0] + d[1]*d[1] + d[2]*d[2];
        float dlen = ( dlensq > 0 ) ? (float) Math.sqrt(dlensq) : 1.0f;
        d[0] /= dlen;
        d[1] /= dlen;
        d[2] /= dlen;

        return d0len;
    }

*/
}
