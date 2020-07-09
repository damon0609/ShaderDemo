using System.Collections;
using UnityEngine;
public class Mesh01 : MonoBehaviour
{
    public int xSize;
    public int ySize;
    private Vector3[] vertex;
    private int[] triangles;
    void OnDrawGizmos()
    {
        if (vertex != null)
        {
            foreach (Vector3 p in vertex)
            {
                Gizmos.DrawSphere(p, 0.1f);
            }
        }
    }
    IEnumerator GenteratorMesh()
    {
        WaitForSeconds wait = new WaitForSeconds(0.1f);
        Mesh mesh = new Mesh();
        mesh.name = "mesh";
        GameObject go = new GameObject("_angle");
        go.AddComponent<MeshFilter>().mesh = mesh;
        go.AddComponent<MeshRenderer>().material = new Material(Shader.Find("Standard"));
        go.transform.parent = gameObject.transform;
        //生成顶点
        int count = (xSize + 1) * (ySize + 1);
        vertex = new Vector3[count];
        for (int y = 0, index = 0; y <= ySize; y++)
        {
            for (int x = 0; x <= xSize; x++, index++)
            {
                Vector3 pos = new Vector3(x, y);
                vertex[index] = transform.TransformPoint(pos);
            }
        }
        mesh.vertices = vertex;

        //生成三角形索引的个数和三角形的个数
        triangles = new int[xSize * ySize * 2 * 3];//一个单位四边形两个三角形
        int triangleIndex = 0;
        for (int j = 0; j < ySize; j++)//xSize*ySize*2表示三角形的个数
        {
            for (int i = 0; i < xSize; i++)
            {
                int startIndex = triangleIndex * 6;
                triangles[startIndex + 0] = i + j * (xSize + 1);
                triangles[startIndex + 1] = (xSize + 1) * (j + 1) + i;//表示纵坐标的间隔值 //纵坐标的行数 
                triangles[startIndex + 2] = i + 1 + j * (xSize + 1);
                mesh.triangles = triangles;
                yield return wait;
                triangles[startIndex + 3] = (xSize + 1) * (j + 1) + i;
                triangles[startIndex + 4] = (xSize + 1) * (j + 1) + i + 1;
                triangles[startIndex + 5] = i + 1 + j * (xSize + 1);
                triangleIndex++;
                mesh.triangles = triangles;
                yield return wait;
            }
        }

        Vector2[] uvs = new Vector2[vertex.Length];
        for (int y = 0, flag = 0; y <= ySize; y++)
        {
            for (int x = 0; x <= xSize; x++, flag++)
            {
                uvs[flag] = new Vector2((float)x / xSize, (float)y / ySize);
            }
        }
        mesh.uv = uvs;

    }

    void Start()
    {
        StartCoroutine(GenteratorMesh());
    }
   
}
