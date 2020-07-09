using UnityEngine;
public class MeshFactory
{
    /// <summary>
    /// xSize,ySize 表示单位四边形的个数
    /// </summary>
    /// <param name="xSize"></param>
    /// <param name="ySize"></param>
    public static Mesh GenterateMesh(int xSize, int ySize)
    {
        int count = (xSize + 1) * (ySize + 1);

        //生成顶点
        Vector3[] vertex = new Vector3[count];
        for (int y = 0, index = 0; y <= ySize; y++)
        {
            for (int x = 0; x <= xSize; x++, index++)
            {
                Vector3 pos = new Vector3(x, y);
                vertex[index] = pos;
            }
        }

        //生成三角形索引的个数 和三角形的个数
        int[] triangles = new int[xSize * ySize * 2 * 3];//一个单位四边形两个三角形
        int triangleIndex = 0;
        for (int j = 0; j < ySize; j++)//xSize*ySize*2表示三角形的个数
        {
            for (int i = 0; i < xSize; i++)
            {
                int startIndex = triangleIndex * 6;
                triangles[startIndex + 0] = i + j * (xSize + 1);
                triangles[startIndex + 1] = (xSize + 1) * (j + 1) + i;//表示纵坐标的间隔值 //纵坐标的行数 
                triangles[startIndex + 2] = i + 1 + j * (xSize + 1);

                triangles[startIndex + 3] = (xSize + 1) * (j + 1) + i;
                triangles[startIndex + 4] = (xSize + 1) * (j + 1) + i + 1;
                triangles[startIndex + 5] = i + 1 + j * (xSize + 1);
                triangleIndex++;
            }
        }


        //绘制UI坐标
        Vector2[] uvs = new Vector2[vertex.Length];
        for (int y = 0, flag = 0; y <= ySize; y++)
        {
            for (int x = 0; x <= xSize; x++, flag++)
            {
                uvs[flag] = new Vector2((float)x / xSize, (float)y / ySize);
            }
        }

        Mesh mesh = new Mesh();
        mesh.vertices = vertex;
        mesh.triangles = triangles;

        //生成包围盒
        mesh.RecalculateBounds();

        //生成法线
        mesh.RecalculateNormals();

        //生成切线
        mesh.RecalculateTangents();

        return mesh;
    }

    

}
