package de.hfkbremen.mesh;

import com.sun.j3d.utils.geometry.GeometryInfo;
import processing.core.PVector;

import javax.media.j3d.GeometryArray;
import javax.vecmath.Point3f;
import java.awt.*;
import java.awt.font.FontRenderContext;
import java.awt.font.GlyphVector;
import java.awt.geom.AffineTransform;
import java.awt.geom.FlatteningPathIterator;
import java.awt.geom.GeneralPath;
import java.awt.geom.PathIterator;
import java.awt.geom.Point2D;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

public class VectorFont {

    public static final int CLOCKWISE = 1;
    public static final int COUNTERCLOCKWISE = -1;
    private final Font mFont;
    private final FontRenderContext mFRC;
    private boolean mStretchToFit = false;
    private boolean mRepeat = false;
    private float mPathFlatness = 1.0f;
    private float mOutlineFlatness = 1.0f;
    private int mInsideFlag = CLOCKWISE;

    public VectorFont(final String pFontName, final float mFontSize) {
        this(Font.decode(pFontName).deriveFont(Font.PLAIN, mFontSize));
    }

    public VectorFont(final Font pFont) {
        mFont = pFont;
        mFRC = new FontRenderContext(null, true, true);
    }

    public void stretch_to_fit(final boolean pStretchToFit) {
        mStretchToFit = pStretchToFit;
    }

    public void repeat(final boolean pRepeat) {
        mRepeat = pRepeat;
    }

    public ArrayList<PVector> outline(String pText) {
        return flattenCharacters(characters(pText));
    }

    public ArrayList<PVector> vertices(String pText) {
        return convertToVertices(characters(pText));
    }

    public ArrayList<PVector> vertices(String pText, final PVector... pPath) {
        return convertToVertices(characters(pText, pPath));
    }

    public ArrayList<PVector> vertices(String pText, ArrayList<PVector> pPath) {
        return convertToVertices(characters(pText, pPath));
    }

    public ArrayList<PVector> vertices(String pText, final Shape pPath) {
        return convertToVertices(characters(pText, pPath));
    }

    public ArrayList<ArrayList<ArrayList<PVector>>> characters(String pText) {
        final ArrayList<ArrayList<ArrayList<PVector>>> myOutlines = new ArrayList<>();
        final GlyphVector mVector = mFont.createGlyphVector(mFRC, pText);
        for (int j = 0; j < mVector.getNumGlyphs(); j++) {
            final Shape mGlyph = mVector.getGlyphOutline(j);
            final ArrayList<ArrayList<ArrayList<PVector>>> mNewCharacters = extractOutlineFromComplexGlyph(mGlyph,
                                                                                                           mOutlineFlatness,
                                                                                                           mInsideFlag);
            myOutlines.addAll(mNewCharacters);
        }
        return myOutlines;
    }

    public ArrayList<ArrayList<ArrayList<PVector>>> characters(final String pText, final PVector... pPath) {
        ArrayList<PVector> mPathPoints = new ArrayList<>();
        Collections.addAll(mPathPoints, pPath);
        return characters(pText, pathJAVA2D(mPathPoints));
    }

    public ArrayList<ArrayList<ArrayList<PVector>>> characters(final String pText, ArrayList<PVector> pPath) {
        return characters(pText, pathJAVA2D(pPath));
    }

    public ArrayList<ArrayList<ArrayList<PVector>>> characters(final String pText, final Shape pPath) {
        final ArrayList<ArrayList<ArrayList<PVector>>> mAllCharacters = new ArrayList<>();
        final GlyphVector mGlyphVector = mFont.createGlyphVector(mFRC, pText);
        final PathIterator it = new FlatteningPathIterator(pPath.getPathIterator(null), mPathFlatness);
        float mPoints[] = new float[6];
        float moveX = 0, moveY = 0;
        float lastX = 0, lastY = 0;
        float mThisX, mThisY;
        int type;
        float mNext = 0;
        int mCurrentCharID = 0;
        int mNumberOfGlyphs = mGlyphVector.getNumGlyphs();

        if (mNumberOfGlyphs == 0) {
            return mAllCharacters;
        }

        float factor = mStretchToFit ? measurePathLength(pPath,
                                                         mPathFlatness) / (float) mGlyphVector.getLogicalBounds().getWidth() : 1.0f;
        float nextAdvance = 0;

        while (mCurrentCharID < mNumberOfGlyphs && !it.isDone()) {
            type = it.currentSegment(mPoints);
            switch (type) {
                case PathIterator.SEG_MOVETO:
                    moveX = lastX = mPoints[0];
                    moveY = lastY = mPoints[1];
                    nextAdvance = mGlyphVector.getGlyphMetrics(mCurrentCharID).getAdvance() * 0.5f;
                    mNext = nextAdvance;
                    break;

                case PathIterator.SEG_CLOSE:
                    mPoints[0] = moveX;
                    mPoints[1] = moveY;
                /* fall through */

                case PathIterator.SEG_LINETO:
                    mThisX = mPoints[0];
                    mThisY = mPoints[1];
                    final float dx = mThisX - lastX;
                    final float dy = mThisY - lastY;
                    float distance = (float) Math.sqrt(dx * dx + dy * dy);
                    if (distance >= mNext) {
                        float r = 1.0f / distance;
                        float angle = (float) Math.atan2(dy, dx);
                        while (mCurrentCharID < mNumberOfGlyphs && distance >= mNext) {
                            final Shape mGlyph = mGlyphVector.getGlyphOutline(mCurrentCharID);
                            final Point2D p = mGlyphVector.getGlyphPosition(mCurrentCharID);
                            final float px = (float) p.getX();
                            final float py = (float) p.getY();
                            final float x = lastX + mNext * dx * r;
                            final float y = lastY + mNext * dy * r;
                            final float advance = nextAdvance;
                            nextAdvance = mCurrentCharID < mNumberOfGlyphs - 1 ? mGlyphVector.getGlyphMetrics(
                                    mCurrentCharID + 1).getAdvance() * 0.5f : 0;
                            final AffineTransform mTransform = new AffineTransform();
                            mTransform.setToTranslation(x, y);
                            mTransform.rotate(angle);
                            mTransform.translate(-px - advance, -py);

                            /* extract outlines */
                            final Shape mShape = mTransform.createTransformedShape(mGlyph);
                            final ArrayList<ArrayList<ArrayList<PVector>>> mNewCharacters = extractOutlineFromComplexGlyph(
                                    mShape,
                                    mOutlineFlatness,
                                    mInsideFlag);
                            mAllCharacters.addAll(mNewCharacters);
                            mNext += (advance + nextAdvance) * factor;
                            mCurrentCharID++;
                            if (mRepeat) {
                                mCurrentCharID %= mNumberOfGlyphs;
                            }
                        }
                    }
                    mNext -= distance;
                    lastX = mThisX;
                    lastY = mThisY;
                    break;
            }
            it.next();
        }
        return mAllCharacters;
    }

    private static ArrayList<ArrayList<ArrayList<PVector>>> extractOutlineFromComplexGlyph(final Shape pShape,
                                                                                           final float pOutlineFlatness,
                                                                                           final int pInsideFlag) {
        final ArrayList<ArrayList<ArrayList<PVector>>> pAllCharacters = new ArrayList<>();
        final ArrayList<ArrayList<PVector>> mSingleCharacter = extractOutlineFromSimpleShape(pShape, pOutlineFlatness);
        /* add simple character or handle and split complex glyphs */
        if (mSingleCharacter.size() <= 1) {
            pAllCharacters.add(mSingleCharacter);
        } else {
            handleComplexGlyphs(mSingleCharacter, pAllCharacters, pInsideFlag);
        }
        return pAllCharacters;
    }

    private static ArrayList<ArrayList<PVector>> extractOutlineFromSimpleShape(final Shape pShape,
                                                                               final float pFlatness) {
        final ArrayList<ArrayList<PVector>> myCharacter = new ArrayList<>();
        if (pFlatness <= 0) {
            return myCharacter;
        }
        final PathIterator mIt = new FlatteningPathIterator(pShape.getPathIterator(null), pFlatness);
        final float[] mSegment = new float[6];
        float x;
        float y;
        float mx = 0;
        float my = 0;
        ArrayList<PVector> mOutline = new ArrayList<>();
        while (!mIt.isDone()) {
            final int mSegmentType = mIt.currentSegment(mSegment);
            switch (mSegmentType) {
                case PathIterator.SEG_MOVETO:
                    x = mx = mSegment[0];
                    y = my = mSegment[1];
                    mOutline.add(new PVector(x, y, 0.0f));
                    break;
                case PathIterator.SEG_LINETO:
                    x = mSegment[0];
                    y = mSegment[1];
                    mOutline.add(new PVector(x, y, 0.0f));
                    break;
                case PathIterator.SEG_CLOSE:
                    x = mx;
                    y = my;
                    mOutline.add(new PVector(x, y, 0.0f));
                    myCharacter.add(mOutline);
                    mOutline = new ArrayList<>();
                    break;
            }
            mIt.next();
        }
        return myCharacter;
    }

    private static void handleComplexGlyphs(final ArrayList<ArrayList<PVector>> pSingleCharacter,
                                            final ArrayList<ArrayList<ArrayList<PVector>>> pAllCharacters,
                                            final int pInsideFlag) {
        /*  sort inside and outside shapes */
        final ArrayList<MShape> mInsideShapes = new ArrayList<>();
        final ArrayList<MShape> mOutsideShapes = new ArrayList<>();
        for (final ArrayList<PVector> mSingleShape : pSingleCharacter) {
            final boolean mIsInside = MeshUtil.isClockWise2D(mSingleShape) == pInsideFlag;
            if (mIsInside) {
                mInsideShapes.add(new MShape(mIsInside, mSingleShape));
            } else {
                mOutsideShapes.add(new MShape(mIsInside, mSingleShape));
            }
        }
        /* add shapes as individual 'characters' if there is no insides */
        if (mInsideShapes.isEmpty()) {
            addMShapes(mOutsideShapes, pAllCharacters);
        } else {
            /* asign inside shapes to outside shapes */
            final Iterator<MShape> mIterator = mInsideShapes.iterator();
            while (mIterator.hasNext()) {
                final MShape mInsideShape = mIterator.next();
                mIterator.remove();
                /* check if inside shape is contained by any outside shape */
                boolean mAddedShape = false;
                for (final MShape mOutsideShape : mOutsideShapes) {
                    /* we just query the first point of the inside shape /( hopefully this will do ) */
                    if (MeshUtil.inside2DPolygon(mInsideShape.shape.get(0), mOutsideShape.shape)) {
                        mOutsideShape.inside_shape.add(mInsideShape);
                        mAddedShape = true;
                        break;
                    }
                }
                /* if we couldn t asign inside shape, turn it into an outside shape */
                if (!mAddedShape) {
                    mOutsideShapes.add(mInsideShape);
                }
            }
            /* add all outside shapes */
            addMShapes(mOutsideShapes, pAllCharacters);
        }
    }

    private static void addMShapes(final ArrayList<MShape> pShapes,
                                   final ArrayList<ArrayList<ArrayList<PVector>>> pAllCharacters) {
        for (final MShape mMasterShape : pShapes) {
            final ArrayList<ArrayList<PVector>> mSimpleCharacter = new ArrayList<>();
            mSimpleCharacter.add(mMasterShape.shape);
            /* add inside shapes */
            if (!mMasterShape.inside_shape.isEmpty()) {
                for (final MShape mInsideShape : mMasterShape.inside_shape) {
                    mSimpleCharacter.add(mInsideShape.shape);
                }
            }
            pAllCharacters.add(mSimpleCharacter);
        }
    }

    private static float measurePathLength(final Shape shape, final float pPathFlatness) {
        PathIterator it = new FlatteningPathIterator(shape.getPathIterator(null), pPathFlatness);
        float points[] = new float[6];
        float moveX = 0, moveY = 0;
        float lastX = 0, lastY = 0;
        float thisX, thisY;
        int type;
        float total = 0;

        while (!it.isDone()) {
            type = it.currentSegment(points);
            switch (type) {
                case PathIterator.SEG_MOVETO:
                    moveX = lastX = points[0];
                    moveY = lastY = points[1];
                    break;

                case PathIterator.SEG_CLOSE:
                    points[0] = moveX;
                    points[1] = moveY;
                    // Fall into....

                case PathIterator.SEG_LINETO:
                    thisX = points[0];
                    thisY = points[1];
                    float dx = thisX - lastX;
                    float dy = thisY - lastY;
                    total += (float) Math.sqrt(dx * dx + dy * dy);
                    lastX = thisX;
                    lastY = thisY;
                    break;
            }
            it.next();
        }

        return total;
    }

    public int insideFlag(final int pInsideFlag) {
        mInsideFlag = pInsideFlag;
        return mInsideFlag;
    }

    public GeneralPath charactersJAVA2D(final String pText, final Shape mPath) {

        final GlyphVector mGlyphVector = mFont.createGlyphVector(mFRC, pText);

        final GeneralPath mResult = new GeneralPath();
        final PathIterator it = new FlatteningPathIterator(mPath.getPathIterator(null), mPathFlatness);
        float mPoints[] = new float[6];
        float moveX = 0, moveY = 0;
        float lastX = 0, lastY = 0;
        float thisX, thisY;
        int type;
        float next = 0;
        int currentChar = 0;
        int length = mGlyphVector.getNumGlyphs();

        if (length == 0) {
            return mResult;
        }

        float factor = mStretchToFit ? measurePathLength(mPath,
                                                         mPathFlatness) / (float) mGlyphVector.getLogicalBounds().getWidth() : 1.0f;
        float nextAdvance = 0;

        while (currentChar < length && !it.isDone()) {
            type = it.currentSegment(mPoints);
            switch (type) {
                case PathIterator.SEG_MOVETO:
                    moveX = lastX = mPoints[0];
                    moveY = lastY = mPoints[1];
                    mResult.moveTo(moveX, moveY);
                    nextAdvance = mGlyphVector.getGlyphMetrics(currentChar).getAdvance() * 0.5f;
                    next = nextAdvance;
                    break;

                case PathIterator.SEG_CLOSE:
                    mPoints[0] = moveX;
                    mPoints[1] = moveY;
                /* fall through */

                case PathIterator.SEG_LINETO:
                    thisX = mPoints[0];
                    thisY = mPoints[1];
                    float dx = thisX - lastX;
                    float dy = thisY - lastY;
                    float distance = (float) Math.sqrt(dx * dx + dy * dy);
                    if (distance >= next) {
                        float r = 1.0f / distance;
                        float angle = (float) Math.atan2(dy, dx);
                        while (currentChar < length && distance >= next) {
                            Shape glyph = mGlyphVector.getGlyphOutline(currentChar);
                            Point2D p = mGlyphVector.getGlyphPosition(currentChar);
                            float px = (float) p.getX();
                            float py = (float) p.getY();
                            float x = lastX + next * dx * r;
                            float y = lastY + next * dy * r;
                            float advance = nextAdvance;
                            nextAdvance = currentChar < length - 1 ? mGlyphVector.getGlyphMetrics(currentChar + 1).getAdvance() * 0.5f : 0;
                            final AffineTransform mTransform = new AffineTransform();
                            mTransform.setToTranslation(x, y);
                            mTransform.rotate(angle);
                            mTransform.translate(-px - advance, -py);
                            mResult.append(mTransform.createTransformedShape(glyph), false);
                            next += (advance + nextAdvance) * factor;
                            currentChar++;
                            if (mRepeat) {
                                currentChar %= length;
                            }
                        }
                    }
                    next -= distance;
                    lastX = thisX;
                    lastY = thisY;
                    break;
            }
            it.next();
        }

        return mResult;
    }

    public GeneralPath pathJAVA2D(final ArrayList<PVector> pPoints) {
        final GeneralPath mPath = new GeneralPath();
        if (pPoints.isEmpty()) {
            return mPath;
        }
        mPath.moveTo(pPoints.get(0).x, pPoints.get(0).y);
        if (pPoints.size() > 1) {
            for (int i = 1; i < pPoints.size(); i++) {
                final PVector v = pPoints.get(i);
                mPath.lineTo(v.x, v.y);
            }
        }
        return mPath;
    }

    public void outline_flatness(float pOutlineFlatness) {
        mOutlineFlatness = pOutlineFlatness;
    }

    public void path_flatness(float pPathFlatness) {
        mPathFlatness = pPathFlatness;
    }

    private static PVector[] triangulate(float[] theData, int[] theStripCount, int[] theContourCount) {
        final GeometryInfo myGeometryInfo = new GeometryInfo(GeometryInfo.POLYGON_ARRAY);
        myGeometryInfo.setCoordinates(theData);
        myGeometryInfo.setStripCounts(theStripCount);
        myGeometryInfo.setContourCounts(theContourCount);

        final GeometryArray myGeometryArray = myGeometryInfo.getGeometryArray();
        final PVector[] myPoints = new PVector[myGeometryArray.getValidVertexCount()];
        for (int i = 0; i < myGeometryArray.getValidVertexCount(); i++) {
            final Point3f p = new Point3f();
            myGeometryArray.getCoordinate(i, p);
            myPoints[i] = new PVector();
            myPoints[i].set(p.x, p.y, p.z);
        }

        return myPoints;
    }

    private static ArrayList<PVector[]> convertToTriangles(final ArrayList<ArrayList<ArrayList<PVector>>> pVectors) {
        final ArrayList<PVector[]> myCharTriangles = new ArrayList<>();
        for (ArrayList<ArrayList<PVector>> pVector : pVectors) {
            final ArrayList<PVector> myVertices = new ArrayList<>();
            final ArrayList<Integer> myVertivesPerShape = new ArrayList<>();
            for (final ArrayList<PVector> myOutline : pVector) {
                myVertivesPerShape.add(myOutline.size());
                myVertices.addAll(myOutline);
            }
            if (pVector.size() > 0) {
                myCharTriangles.add(triangulate(MeshUtil.toArray3f(myVertices),
                                                MeshUtil.toArray(myVertivesPerShape),
                                                new int[]{pVector.size()}));
            }
        }
        return myCharTriangles;
    }

    public static ArrayList<PVector> convertToVertices(final ArrayList<ArrayList<ArrayList<PVector>>> pVectors) {
        final ArrayList<PVector> myCharTriangles = new ArrayList<>();
        for (ArrayList<ArrayList<PVector>> pVector : pVectors) {
            final ArrayList<PVector> myVertices = new ArrayList<>();
            final ArrayList<Integer> myVertivesPerShape = new ArrayList<>();
            for (final ArrayList<PVector> myOutline : pVector) {
                myVertivesPerShape.add(myOutline.size());
                myVertices.addAll(myOutline);
            }
            if (pVector.size() > 0) {
                final PVector[] mTriangle = triangulate(MeshUtil.toArray3f(myVertices),
                                                        MeshUtil.toArray(myVertivesPerShape),
                                                        new int[]{pVector.size()});
                Collections.addAll(myCharTriangles, mTriangle);
            }
        }
        return myCharTriangles;
    }

    public static ArrayList<PVector> flattenCharacters(final ArrayList<ArrayList<ArrayList<PVector>>> pVectors) {
        final ArrayList<PVector> mOutlinePoints = new ArrayList<>();
        for (ArrayList<ArrayList<PVector>> pVector : pVectors) {
            final ArrayList<PVector> myVertices = new ArrayList<>();
            pVector.forEach(myVertices::addAll);
            mOutlinePoints.addAll(myVertices);
        }
        return mOutlinePoints;
    }

    private static class MShape {

        final boolean inside;

        final ArrayList<PVector> shape;

        final ArrayList<MShape> inside_shape;

        private MShape(final boolean pInside, final ArrayList<PVector> pShape) {
            inside = pInside;
            shape = pShape;
            inside_shape = new ArrayList<>();
        }
    }
}
